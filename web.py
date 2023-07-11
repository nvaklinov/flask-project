#!/usr/bin/python

from flask import Flask
from flask import render_template
import os

app = Flask(__name__)

env=os.getenv('ENV')

@app.route("/")
def home():
    return f"Hello from {env}"

@app.route("/picture")
def pic():
    return render_template('index.html')

if __name__ == "__main__":
         app.run(host='0.0.0.0')
