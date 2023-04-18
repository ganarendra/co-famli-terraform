# gather credentials for the assumed role
echo 'gathering credentials...'
python $(AWSCommands.secureFilePath) '$(test_commands_data)' > out.txt
accessKeyID=$(cat out.txt | grep 'AccessKeyId' | awk '{print $2}' | tr -d '",')
secretAccessKey=$(cat out.txt | grep 'SecretAccessKey' | awk '{print $2}' | tr -d '",')
sessionToken=$(cat out.txt | grep 'SessionToken' | awk '{print $2}' | tr -d '",')
expiration=$(cat out.txt | grep 'Expiration' | awk '{print $2}' | tr -d '"')
rm out.txt

echo "access key is set. ##vso[task.setvariable variable=access_key;isSecret=false;isOutput=true;]$accessKeyID"
echo "secret key is set. ##vso[task.setvariable variable=secret_key;isSecret=false;isOutput=true;]$secretAccessKey"
echo "session token is set. ##vso[task.setvariable variable=session_token;isSecret=false;isOutput=true;]$sessionToken"
echo "credentials expire at $expiration"
