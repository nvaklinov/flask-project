FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y python && apt-get install -y python-pip

#RUN chmod +x /root/script.sh

WORKDIR /root/

expose 5000

CMD ["sh", "-c" , " ./script.sh"]
