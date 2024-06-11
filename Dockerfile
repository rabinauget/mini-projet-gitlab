FROM alpine:3.20
LABEL maintainer="rabinauget@gmail.com"
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install nginx -y && apt clean -y
RUN rm -Rf /var/www/html/*
COPY . /var/www/html/
EXPOSE 80
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]