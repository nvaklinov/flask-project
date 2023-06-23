from flask import Flask
import os

app = Flask(__name__)

env = os.environ.get('env')

@app.route("/env")
def home():
   return f"The secret value is: {env}"

if __name__ == "__main__":
    app.run(port=80, host='0.0.0.0', debug=True)