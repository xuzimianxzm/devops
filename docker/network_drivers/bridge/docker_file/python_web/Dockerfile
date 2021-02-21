FROM python:3.8.2

WORKDIR /usr/src/app
COPY code/python/http_server.py ./
EXPOSE 8080
CMD [ "python3", "http_server.py" ]
# CMD [ "python3","-m", "http.server","8090"]
# CMD [ "python3", "http_server.py" ,"8090"]