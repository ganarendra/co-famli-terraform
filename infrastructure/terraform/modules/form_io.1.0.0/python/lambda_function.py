import os
import json
import boto3
import shutil

def lambda_handler(event, context):
    get_files_from_path("/mnt/lambda")
    print(event)
    dir_path = os.path.dirname(os.path.realpath(__file__))
    print(dir_path)
    print(os.listdir(dir_path))
    path = os.environ['LAMBDA_TASK_ROOT'] + "/default.conf"
    path2 = os.environ['LAMBDA_TASK_ROOT'] + "/rds-combined-ca-bundle.pem"

    isExist1 = os.path.exists("/mnt/lambda/nginx")
    try:
      if not isExist1:
        os.mkdir("/mnt/lambda/nginx")
    except Exception as e:
      print(e)
      print("failed create nginx")

    isExist2 = os.path.exists("/mnt/lambda/formio")
    try:
      if not isExist2:
        os.mkdir("/mnt/lambda/formio")
    except Exception as e:
      print(e)
      print("failed create formio")

    try:
      shutil.move(path, "/mnt/lambda/nginx/nginx.conf")
    except Exception as e:
      print(e)
      print("failed write nginx")

    try:
      shutil.move(path2, "/mnt/lambda/formio/rds-combined-ca-bundle.pem")
    except Exception as e:
      print(e)
      print("failed write docdb")

    print("===========================")
    print(os.listdir("/mnt/lambda/nginx"))
    print(os.listdir("/mnt/lambda/formio"))
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Status":"Script Completed"
        })
    }


def get_files_from_path(file_path):
        """
        Returns the files found at the file_path
        :param file_path: string
        :return list:
        """
        # NOTE: file_path = '/my-efs/
        for root, dirs, files in os.walk(file_path):
          for name in files:
            print(os.path.join(root, name))
          for name in dirs:
            print(os.path.join(root, name))
