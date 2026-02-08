FROM nginx:alpine
COPY lurches.html /usr/share/nginx/html/index.html
EXPOSE 8080
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf
