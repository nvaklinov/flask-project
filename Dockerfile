from python

RUN mkdir /app/

COPY . /app/

RUN pip install flask

CMD ["python","/app/web.py"]
