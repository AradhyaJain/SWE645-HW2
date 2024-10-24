# Aradhya Jain – G01462086
# Gayatri Ramchandra Vaidya – G01460522

# Use a base image. Here, we use nginx as a web server.
FROM nginx:alpine

# Copy your HTML form into the container's file system
COPY survey.html /usr/share/nginx/html

# Copy the CSS file into the Nginx default HTML directory
COPY styles.css /usr/share/nginx/html/styles.css

# Copy the Logo file into the Nginx default HTML directory
COPY Nuniversity_logo.png /usr/share/nginx/html/Nuniversity_logo.png
