# FROM nginx:stable-alpine
# COPY index.html /usr/share/nginx/html/index.html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

FROM cgr.dev/chainguard/nginx
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
