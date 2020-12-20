FROM python:3

ADD web.py /

CMD ["python", "./web.py"]
