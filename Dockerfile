FROM ubuntu:latest

RUN apt-get update -y && apt-get install -y python && apt-get install -y python-pip
WORKDIR /app/

COPY . .
RUN pip install -r requirements.txt && chmod +x start.sh

CMD ["bash", "start.sh"]
