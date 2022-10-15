FROM nginx:latest
CMD cp -p https://github.com/nsen-devops/mydevrepos/blob/master/index.html /var/www/html/
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
