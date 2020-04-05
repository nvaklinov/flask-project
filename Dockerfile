FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y && apt-get install python3 -y && apt-get install python-pip -y

COPY . .

expose 5000

CMD "./script.sh"
