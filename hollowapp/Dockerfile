FROM python:3.6-alpine

RUN adduser -D ubuntu && \
    mkdir -p /home/ubuntu

WORKDIR /home/ubuntu
COPY ./ ./
RUN apk add --update \
	&& apk add --no-cache --virtual .build-deps \
		mariadb-dev \
		gcc \
		musl-dev \
	&& apk del .build-deps && \
    apk add --no-cache mysql-client && \
    python -m venv venv && \
	venv/bin/pip install --upgrade setuptools && \
    venv/bin/pip install -r requirements.txt && \
    venv/bin/pip install gunicorn PyMySQL==0.8.1 && \
    chmod +x boot.sh && \
	chown -R ubuntu:ubuntu /home/ubuntu/
	
ENV FLASK_APP taskapp.py
USER ubuntu
EXPOSE 5000
ENTRYPOINT ["./boot.sh"]