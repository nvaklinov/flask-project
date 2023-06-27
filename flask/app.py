#!/usr/bin/python

from flask import Flask
from flask import render_template
import os

app = Flask(__name__)

env=os.getenv('ENV')

@app.route("/")
def home():
	return "Hello, Nik from Baev!"

@app.route("/env")
def environment():
	return env

@app.route("/picture")
def pic():
	return render_template('index.html')

@app.route("/pragmatic")
def salvador():
	return "You are almost DevOps Gurus"

if __name__ == "__main__":
	app.run(
  port=5000,
  host='0.0.0.0',debug=True)
