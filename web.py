#!/usr/bin/python

from flask import Flask
from flask import render_template

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello, World!"

@app.route("/picture")
def pic():
        return render_template('index.html')

@app.route("/pragmatic")
def salvador():
    return "Hello, pragmatic!"
if __name__ == "__main__":
    app.run(host='0.0.0.0',debug=True)