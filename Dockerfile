
FROM nginx:alpine

# Copier les fichiers buildés depuis l'étape précédente vers le répertoire de contenu de Nginx

COPY . .

# Exposer le port 80 pour le serveur Nginx

EXPOSE 80
