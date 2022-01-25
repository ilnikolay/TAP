FROM python:alpine

ENV DB_NAME=$DB_NAME
ENV DB_USER=$DB_USER
ENV DB_HOST=$DB_HOST
ENV DB_PASSWORD=${DB_PASSWORD}


RUN pip3 install psycopg2-binary

WORKDIR /listener

COPY dsn.py .

EXPOSE 80

ENTRYPOINT [ "python", "dsn.py" ]
CMD [ "${DB_NAME}", "${DB_USER}", "${DB_HOST}", "${DB_PASSWORD}" ]