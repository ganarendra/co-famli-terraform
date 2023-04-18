# set up credentials
export AWS_ACCESS_KEY_ID=$(creds.access_key)
export AWS_SECRET_ACCESS_KEY=$(creds.secret_key)
export AWS_DEFAULT_REGION=$(aws_region)
export AWS_SESSION_TOKEN=$(creds.session_token)

# you may now run commands using the credentials from the assumed role
# example command to be run
echo "listing s3 buckets..."
aws s3 ls
