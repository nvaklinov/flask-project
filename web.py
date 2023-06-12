#!/usr/bin/python

#test
from flask import Flask
from flask import render_template
import os

app = Flask(__name__)

env=os.getenv('ENV')

@app.route("/")
def home():
    return render_template('index.html')

if __name__ == "__main__":
    if env == "dev" or env == None:
         app.run(host='0.0.0.0',debug=True)
    else:
         app.run(host='0.0.0.0')
