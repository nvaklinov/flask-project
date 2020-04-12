from ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y python && apt-get install -y python-pip

COPY script.sh /root/script.sh
COPY requirements.txt /root/requirements.txt
COPY static /root/static
COPY templates /root/tempaltes
COPY web.py /root/web.py

RUN chmod +x /root/script.sh

expose 5000

WORKDIR /root/

CMD ["sh", "-c" , "./script.sh"]
