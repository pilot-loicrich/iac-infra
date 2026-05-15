-- Schema initial de la base de donnees
-- Execute automatiquement par PostgreSQL au premier demarrage du conteneur

CREATE TABLE IF NOT EXISTS public.utilisateurs (
    id   SERIAL PRIMARY KEY,
    nom  VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Donnees de test
INSERT INTO public.utilisateurs (nom, email) VALUES
    ('Loic',  'loic@test.com'),
    ('Admin', 'admin@test.com')
ON CONFLICT (email) DO NOTHING;
