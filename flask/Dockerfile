FROM python AS builder

RUN mkdir app

COPY . /app/

RUN pip install -r /app/requirements.txt

WORKDIR /app/

CMD ["python","app.py"]
