# Image WordPress custom durcie (haute dispo / securite)
# Base officielle WordPress + configuration PHP personnalisee
FROM wordpress:latest

# Configuration PHP : limites d'upload et memoire adaptees a la production
COPY docker/config/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Durcissement : interdire l'edition de fichiers depuis l'admin WordPress
ENV WORDPRESS_CONFIG_EXTRA="define('DISALLOW_FILE_EDIT', true);"

EXPOSE 80
