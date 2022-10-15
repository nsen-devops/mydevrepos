FROM nginx:latest
CMD wget https://github.com/nsen-devops/mydevrepos/blob/master/index.html .
CMD cp -p index.html /var/www/html/
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
