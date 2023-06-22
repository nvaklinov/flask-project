#!/usr/bin/python 
from flask import Flask
from flask import render_template
import os

app = Flask(__name__)
env = os.getenv("ENV")


def get_env_password():
    with open(f'/app/secrets/myapp/{env}', 'r') as f:
        password = f.read()
        return(password)

@app.route("/env")
def home(): return f"This is {env} and the password is {get_env_password()}"


@app.route("/picture")
def pic():
    return render_template('index.html')


@app.route("/pragmatic")
def salvador():
    return f"hello from {env}"


if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
