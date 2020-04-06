from ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y python && apt-get install -y python-pip

COPY run_app.sh /root/run_app.sh
COPY requirements.txt /root/requirements.txt
COPY static /root/static
COPY templates /root/templates
COPY web.py /root/web.py

RUN chmod +x /root/run_app.sh

WORKDIR /root/
expose 5000

CMD ["sh", "-c" , " ./run_app.sh"]
