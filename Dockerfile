# FROM nginx:stable-alpine
# COPY index.html /usr/share/nginx/html/index.html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

FROM nginx:1.25-alpine

RUN apk update && apk upgrade

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
