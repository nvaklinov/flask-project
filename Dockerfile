FROM python

RUN pip install flask && mkdir app

COPY . /app/

EXPOSE 5000

CMD ["python","/app/web.py"]