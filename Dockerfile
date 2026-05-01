# Use Nginx to serve the content
FROM nginx:alpine

# Copy your index.html into the Nginx folder
COPY index.html /usr/share/nginx/html/index.html
