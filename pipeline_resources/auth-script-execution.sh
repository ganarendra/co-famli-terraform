# install dependencies
python -m pip install --upgrade pip
pip install boto3
pip install awscli --upgrade --user

# perform release
echo 'performing release...'
python $(AWSAuth.secureFilePath) '$(test_auth_data)' '$(System.DefaultWorkingDirectory)/$(Release.PrimaryArtifactSourceAlias)/terraform_$(test_env_id)/infrastructure/terraform/$(test_env_id)/'
