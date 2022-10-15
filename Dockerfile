FROM nginx:latest
#RUN apt-get update \
# && apt-get install -y wget
#WORKDIR /usr/share/nginx/html/
#CMD rm -rf index.html
#RUN wget -O /usr/share/nginx/html/index.html https://github.com/nsen-devops/mydevrepos/blob/master/index.html
RUN echo "this is my test web-site" > /usr/share/nginx/html/index.html
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
