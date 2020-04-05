from ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y python && apt-get install -y python-pip

COPY script.sh /root/script.sh
COPY requirements.txt /root/requirements.txt
COPY static /root/static
COPY web.py /root/web.py
COPY templates /root/templates

RUN chmod +x /root/script.sh

expose 5000

CMD /root/script.sh
