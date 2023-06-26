import boto3
from botocore.exceptions import BotoCoreError, ClientError
from flask import Flask
import os
# from kubernetes import client, config

# def get_secret(namespace, secret_name):
#     config.load_incluster_config()  # Load the Kubernetes configuration from within the Pod

#     v1 = client.CoreV1Api()
#     try:
#         secret = v1.read_namespaced_secret(secret_name, namespace)
#     except client.exceptions.ApiException as e:
#         return f"An error occurred: {e}"

#     return secret.data['secretKey']  # Replace 'secretKey' with the key you specified in your ExternalSecret


################ function get secret ################################
# def get_secret(secret_name, region_name):
#     session = boto3.Session(
#        aws_access_key_id='',
#        aws_secret_access_key='',
#        region_name=region_name
#     )
    # session = boto3.Session(region_name="us-east-1")
    # client = session.client(service_name='secretsmanager')

    # try:
    #     get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    # except ClientError as e:
    #     return f"An error occurred: {e}"
    # else:
    #     if 'SecretString' in get_secret_value_response:
    #         secret = get_secret_value_response['SecretString']
    #     else:
    #         secret = get_secret_value_response['SecretBinary']

    # return secret


app = Flask(__name__)
env=os.getenv('ENV')

@app.route('/env')
def print_env():
    return env                            #secret =  get_secret("kube-system","external-secret") #get_secret("example_secret", "us-east-1")
                            #return f'The secret value is: {secret}' 

@app.route('/')
def hello_world():
    return "Hello DevOps! :) "#get_secret("example_secret", "us-east-1")

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
