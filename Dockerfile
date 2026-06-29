FROM nginx:stable-alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


# Stage 1: Builder
# -------------------------
# FROM nginx:1.25-alpine AS builder

# # Remove default content
# RUN rm -rf /usr/share/nginx/html/*

# # Copy your app
# COPY index.html /usr/share/nginx/html/index.html


# # -------------------------
# # Stage 2: Final Runtime
# # -------------------------
# FROM nginx:1.25-alpine

# # Update only security patches (optional but controlled)
# RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# # Copy only required files
# COPY --from=builder /usr/share/nginx/html /usr/share/nginx/html

# # Expose port
# EXPOSE 80

# # Start nginx
# CMD ["nginx", "-g", "daemon off;"]


# FROM nginx:1.25-alpine

# COPY index.html /usr/share/nginx/html/index.html

# EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]





# Intentionally Vulnerable Dockerfile
# FOR SECURITY TESTING ONLY

FROM ubuntu:16.04

# Run as root (bad practice)
USER root

# Install outdated and unnecessary packages
RUN apt-get update && apt-get install -y \
    telnet \
    ftp \
    net-tools \
    wget \
    curl \
    vim \
    openssh-server \
    apache2 \
    python \
    && rm -rf /var/lib/apt/lists/*

# # Hardcoded credentials
# ENV DB_USER=admin
# ENV DB_PASSWORD=Password123

# # Expose multiple ports unnecessarily
# EXPOSE 22
# EXPOSE 80
# EXPOSE 8080

# # Create a weak user password
# RUN useradd testuser && echo "testuser:test123" | chpasswd

# # Give excessive privileges
# RUN chmod 777 /tmp

# # Copy application files
# COPY . /app

# # Run container as root
# WORKDIR /app

# CMD ["/bin/bash"]

