# Aradhya Jain – G01462086
# Gayatri Ramchandra Vaidya – G01460522

# Use a base image. Here, we use nginx as a web server.
FROM nginx:alpine

# Copy your HTML form into the container's file system
COPY survey.html /usr/share/nginx/html
