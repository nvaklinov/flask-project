FROM python:3.9-slim

RUN mkdir /app/

COPY . /app/
WORKDIR /app/
RUN pip install --upgrade pip
RUN pip install --no-cache-dir flask boto3

CMD ["python","/app/web.py"]
