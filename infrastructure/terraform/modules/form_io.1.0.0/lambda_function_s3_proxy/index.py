import botocore
import boto3
import base64
from os import environ
s3_client = boto3.client('s3')

def get_bucket_content(bucket, path):
    if path.startswith('/'):
        key = path[1:]
    else:
        key = path
    print(f'Reading {key} from {bucket}')
    try:
        obj = s3_client.get_object(
            Bucket=bucket,
            Key=key,
        )

        return {
            'Body': obj['Body'].read(),
            'ContentType': obj['ContentType']
        }
    except botocore.exceptions.ClientError as e:
        print(e)

def lambda_handler(event, context):
    print(event['path'])

    path = event['path']

    if path == '/' or path == '':
        path = '/index.html'


    bucket_name = environ.get('s3_bucket')
    content = get_bucket_content(bucket_name, path)

    if content:
      return {
        'statusCode': 200,
        'isBase64Encoded': True,
        'body': base64.b64encode(content['Body']).decode('utf-8'),
        'headers': {
            'Content-Type': content['ContentType']
        },
      }

    return {
        'statusCode': 404,
        'statusDescription': '404 Not Found',
        'isBase64Encoded': False,
        'headers': {
            'Content-Type': 'text/html'
        },
        'body': '<p>Not found</p>'
    }
