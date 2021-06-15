FROM nginx:latest
CMD cp -p /root/index.html /var/www/html/
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
