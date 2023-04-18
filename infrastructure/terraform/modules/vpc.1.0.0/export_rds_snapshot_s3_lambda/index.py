import boto3

def lambda_handler(event, context):
  print(event)
  result = "Hello World"
  return {
    'statusCode' : 200,
    'body': result
  }
