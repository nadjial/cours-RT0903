FROM python:3-alpine
RUN pip3 install flask
COPY ./server.py /usr/src/app/
CMD python3 /usr/src/app/server.py
