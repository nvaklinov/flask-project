from python

RUN pip install flask && mkdir app/

COPY . /app/

CMD ["python","/app/web.py"]
