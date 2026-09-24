FROM nginx:alpine

# Copie d'une page HTML de test minimale
RUN echo "<h1>FoodTrack - Application en ligne</h1>" > /usr/share/nginx/html/index.html

# Exposition du port HTTP standard
EXPOSE 80

# Lancement de Nginx en premier plan
CMD ["nginx", "-g", "daemon off;"]