"""
Micro-relay Alertmanager → Discord
Reçoit le webhook JSON d'Alertmanager et le retransmet
en format natif Discord ({"content": "..."}).
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
import json, urllib.request, os, logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
log = logging.getLogger(__name__)

DISCORD_URL = os.environ.get('DISCORD_WEBHOOK_URL', '')

SEVERITY_ICON = {'critical': '🔴', 'warning': '🟠', 'info': '🔵'}
STATUS_LABEL   = {'firing': '🔴  ALERTE EN COURS', 'resolved': '✅  RÉSOLUE'}


class RelayHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            length = int(self.headers.get('Content-Length', 0))
            body   = json.loads(self.rfile.read(length))

            status = body.get('status', 'firing')
            header = STATUS_LABEL.get(status, status.upper())
            lines  = [f"**{header}**"]

            for alert in body.get('alerts', []):
                labels      = alert.get('labels', {})
                annotations = alert.get('annotations', {})
                name = labels.get('alertname', 'Inconnu')
                sev  = labels.get('severity', '')
                inst = labels.get('instance', '')
                desc = annotations.get('description', annotations.get('summary', ''))
                icon = SEVERITY_ICON.get(sev, '⚠️')
                lines.append(
                    f"\n{icon} **{name}**"
                    f"\n› Instance : `{inst}`"
                    f"\n› Sévérité : `{sev}`"
                    + (f"\n› {desc}" if desc else "")
                )

            content = '\n'.join(lines)[:2000]   # Discord limit
            payload = json.dumps({'content': content, 'username': 'Alertmanager'}).encode()

            req = urllib.request.Request(
                DISCORD_URL, data=payload,
                headers={
                    'Content-Type': 'application/json',
                    'User-Agent': 'DiscordBot (https://github.com, 1.0)',
                },
                method='POST'
            )
            with urllib.request.urlopen(req, timeout=10) as resp:
                log.info("Discord response: %s", resp.status)

        except Exception as exc:
            log.error("Relay error: %s", exc)

        self.send_response(200)
        self.end_headers()

    def log_message(self, fmt, *args):
        log.info(fmt, *args)


if __name__ == '__main__':
    if not DISCORD_URL:
        log.error("DISCORD_WEBHOOK_URL not set!")
    log.info("Relay listening on :9094 → %s", DISCORD_URL[:60] + '...')
    HTTPServer(('', 9094), RelayHandler).serve_forever()
