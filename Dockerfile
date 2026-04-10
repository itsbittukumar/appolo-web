# FROM nginx:stable-alpine
# COPY index.html /usr/share/nginx/html/index.html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]


# -------------------------
# Stage 1: Builder
# -------------------------
FROM nginx:1.25-alpine AS builder

# Remove default content
RUN rm -rf /usr/share/nginx/html/*

# Copy your app
COPY index.html /usr/share/nginx/html/index.html


# -------------------------
# Stage 2: Final Runtime
# -------------------------
FROM nginx:1.25-alpine

# Update only security patches (optional but controlled)
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Copy only required files
COPY --from=builder /usr/share/nginx/html /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

