FROM nginx:alpine
COPY lurches.html /usr/share/nginx/html/index.html
COPY favicon.svg favicon-32.png favicon.ico /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod 644 /usr/share/nginx/html/index.html /usr/share/nginx/html/favicon*
EXPOSE 8080
