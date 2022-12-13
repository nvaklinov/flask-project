#!/usr/bin/python

from flask import Flask
from flask import render_template
import os

app = Flask(__name__)

env=os.getenv('ENV')

@app.route("/")
def home():
    return "Hello, World!"

@app.route("/picture")
def pic():
        return render_template('index.html')

@app.route("/pragmatic")
def salvador():
    result= f"hello from {env}"
    return result
if __name__ == "__main__":
    app.run(host='0.0.0.0',debug=True)
