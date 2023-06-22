FROM python:3.10.10-bullseye

RUN mkdir /app/

COPY . /app/

RUN pip install -r app/requirements.txt

CMD ["python","/app/web.py"]