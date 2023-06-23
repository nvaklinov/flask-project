FROM python:3.9-slim
RUN pip install --upgrade pip
RUN pip install --no-cache-dir flask
COPY app.py /usr/src/app/
CMD ["python", "/usr/src/app/app.py"]