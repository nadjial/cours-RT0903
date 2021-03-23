FROM python:3.7-alpine

RUN pip install --no-cache-dir flask

COPY ./app /usr/src/cours-RT0903/

# run the application
CMD python /usr/src/cours-RT0903/main.py
