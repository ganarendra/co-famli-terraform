# assign list of all environments from artifact
env_list=$(cat $(System.DefaultWorkingDirectory)/$(Release.PrimaryArtifactSourceAlias)/pipeline_resources/env_list.txt)

# get name of first environment in list
# this will be used to pull global values that are duplicated between all envs such as region and terraform version
firstenv=$(echo $env_list | awk '{print $1}')
# echo "first environment: $firstenv"

# echo "contents of terraform_$firstenv/build_params.json:"
# cat $(System.DefaultWorkingDirectory)/$(Release.PrimaryArtifactSourceAlias)/terraform_$firstenv/build_params.json

# now gather variables that are used across all stages
for varname in agency project aws_region terraform_version destination
do
    # echo "gathering global variable $varname..."
    declare "$varname"=$(cat $(System.DefaultWorkingDirectory)/$(Release.PrimaryArtifactSourceAlias)/terraform_$firstenv/infrastructure/terraform/$firstenv/build_params.json | jq ".$varname" | tr -d '"')
    # echo "value of global variable $varname: ${!varname}"
done

# set agency
echo "##vso[task.setvariable variable=agency]$(echo $agency)"

# set project
echo "##vso[task.setvariable variable=project]$(echo $project)"

# set terraform version
echo "##vso[task.setvariable variable=terraform_version]$(echo $terraform_version)"

# set aws region
echo "##vso[task.setvariable variable=aws_region]$(echo $aws_region)"

# set destination
echo "##vso[task.setvariable variable=destination]$(echo $destination)"

# pull in correct auth_data template
case $destination in
    "labs")
        echo "using auth_data template for oit_cloud_labs..."
        authData='{ "aws_region": "###REGION###", "username": "$(auth_user)", "user_pass": "$(auth_pw)", "client_id": "$(cog_client_id)", "app_secret": "$(cog_app_secret)", "base_url": "$(service_endpointv2)", "api_key": "$(endpoint_k)", "account": "$(account_id)", "release_id": "$(Release.ReleaseId)", "release_name": "$(Release.ReleaseName)", "azdo_project": "$(System.TeamProject)", "tmp_role_identifier": "###AGENCY###-###PROJECT###-###ENV###-release", "release_triggered": "$(Release.RequestedFor)", "role_lookup": "###ACCOUNT###-azdo-iac-tmp-base" }'
        authCommandsData='{ "aws_region": "###REGION###", "username": "$(auth_user)", "user_pass": "$(auth_pw)", "client_id": "$(cog_client_id)", "app_secret": "$(cog_app_secret)", "base_url": "$(service_endpointv2)", "api_key": "$(endpoint_k)", "account": "$(account_id)", "release_id": "$(Release.ReleaseId)", "release_name": "$(Release.ReleaseName)", "azdo_project": "$(System.TeamProject)", "tmp_role_identifier": "###AGENCY###-###PROJECT###-###ENV###-release-commands", "release_triggered": "$(Release.RequestedFor)", "role_lookup": "###ACCOUNT###-custom-###AGENCY###-###PROJECT###-release" }'
        ;;
    "commercial")
        echo "using auth_data template for oit_commercial"
        authData='{ "aws_region": "###REGION###", "username": "$(auth_user)", "user_pass": "$(auth_pw)", "client_id": "$(cog_client_id)", "app_secret": "$(cog_app_secret)", "base_url": "$(service_endpointv2)", "api_key": "$(endpoint_k)", "account": "$(account_id)", "release_id": "$(Release.ReleaseId)", "release_name": "$(Release.ReleaseName)", "azdo_project": "$(System.TeamProject)", "tmp_role_identifier": "###AGENCY###-###PROJECT###-###ENV###-release", "release_triggered": "$(Release.RequestedFor)", "role_lookup": "###ACCOUNT###-azdo-iac-tmp-base" }'
        authCommandsData='{ "aws_region": "###REGION###", "username": "$(auth_user)", "user_pass": "$(auth_pw)", "client_id": "$(cog_client_id)", "app_secret": "$(cog_app_secret)", "base_url": "$(service_endpointv2)", "api_key": "$(endpoint_k)", "account": "$(account_id)", "release_id": "$(Release.ReleaseId)", "release_name": "$(Release.ReleaseName)", "azdo_project": "$(System.TeamProject)", "tmp_role_identifier": "###AGENCY###-###PROJECT###-###ENV###-release-commands", "release_triggered": "$(Release.RequestedFor)", "role_lookup": "###ACCOUNT###-custom-###AGENCY###-###PROJECT###-release" }'
        ;;
    "govcloud")
        echo "using auth_data template for oit_govcloud"
        authData='{ "aws_region": "###REGION###", "username": "$(auth_user)", "user_pass": "$(auth_pw)", "client_id": "$(cog_client_id)", "app_secret": "$(cog_app_secret)", "base_url": "$(service_endpointv2)", "api_key": "$(endpoint_k)", "account": "$(account_id)", "release_id": "$(Release.ReleaseId)", "release_name": "$(Release.ReleaseName)", "azdo_project": "$(System.TeamProject)", "tmp_role_identifier": "###AGENCY###-###PROJECT###-###ENV###-release", "release_triggered": "$(Release.RequestedFor)", "role_lookup": "###ACCOUNT###-azdo-iac-tmp-base" }'
        authCommandsData='{ "aws_region": "###REGION###", "username": "$(auth_user)", "user_pass": "$(auth_pw)", "client_id": "$(cog_client_id)", "app_secret": "$(cog_app_secret)", "base_url": "$(service_endpointv2)", "api_key": "$(endpoint_k)", "account": "$(account_id)", "release_id": "$(Release.ReleaseId)", "release_name": "$(Release.ReleaseName)", "azdo_project": "$(System.TeamProject)", "tmp_role_identifier": "###AGENCY###-###PROJECT###-###ENV###-release-commands", "release_triggered": "$(Release.RequestedFor)", "role_lookup": "###ACCOUNT###-custom-###AGENCY###-###PROJECT###-release" }'
        ;;
    *)
        # the default match - if we are here something is wrong
        echo "please use a recognized destination for your release."
        exit 1
        ;;
esac

# make auth_data and commands_data substitutions for region
authData=$(echo $authData | sed "s/###REGION###/$aws_region/g")
authCommandsData=$(echo $authCommandsData | sed "s/###REGION###/$aws_region/g")

# gather variables that are used in specific stages
for envname in $env_list
do
    # echo "$envname build_params.json contents:"
    # cat $(System.DefaultWorkingDirectory)/$(Release.PrimaryArtifactSourceAlias)/terraform_$envname/build_params.json
    echo "gathering variables for environment $envname..."
    for varname in env_id tmp_role_identifier role_account
    do
        declare "${envname}_${varname}"=$(cat $(System.DefaultWorkingDirectory)/$(Release.PrimaryArtifactSourceAlias)/terraform_$envname/infrastructure/terraform/$envname/build_params.json | jq ".$varname" | tr -d '"')
        env_varname="${envname}_${varname}"
        # echo "value of variable ${envname}_${varname}: ${!env_varname}"
    done
done

# build auth_data and commands_data for each environment
for envname in $env_list
do
    echo "building auth_data for environment $envname..."
    envname_identifier="${envname}_tmp_role_identifier"
    envname_account="${envname}_role_account"

    # make all needed substitutions for auth_data
    tmpAuthData=$(echo $authData | sed "s/###ENV###/$envname/g")
    tmpAuthData=$(echo $tmpAuthData | sed "s/###ACCOUNT###/${!envname_account}/g")
    tmpAuthData=$(echo $tmpAuthData | sed "s/###AGENCY###-###PROJECT###/${agency}-${project}/g")
    declare "${envname}_auth_data"="$tmpAuthData"

    # make all needed substitutions for commands_data
    tmpAuthData=$(echo $authCommandsData | sed "s/###ENV###/$envname/g")
    tmpAuthData=$(echo $tmpAuthData | sed "s/###ACCOUNT###/${!envname_account}/g")
    tmpAuthData=$(echo $tmpAuthData | sed "s/###AGENCY###-###PROJECT###/${agency}-${project}/g")
    declare "${envname}_commands_data"="$tmpAuthData"

    # set environment specific azdo variables for later tasks
    envname_env_id="${envname}_env_id"
    echo "##vso[task.setvariable variable=${envname}_env_id]${!envname_env_id}"
    echo "##vso[task.setvariable variable=${envname}_tmp_role_identifier]${!envname_identifier}"
    echo "##vso[task.setvariable variable=${envname}_role_account]${!envname_account}"
    envname_auth_data="${envname}_auth_data"
    echo "##vso[task.setvariable variable=${envname}_auth_data]${!envname_auth_data}"
    envname_commands_data="${envname}_commands_data"
    echo "##vso[task.setvariable variable=${envname}_commands_data]${!envname_commands_data}"
done

# uncomment for troubleshooting
echo "===============debugging==============="
echo "terraform_version: $terraform_version"
echo "aws region: $aws_region"
for envname in $env_list
do
    envname_env_id="${envname}_env_id"
    echo "${envname}_env_id: ${!envname_env_id}"
    envname_identifier="${envname}_tmp_role_identifier"
    echo "${envname}_tmp_role_identifer: ${!envname_identifier}"
    envname_account="${envname}_role_account"
    echo "${envname}_role_account: ${!envname_account}"
    envname_auth_data="${envname}_auth_data"
    echo "${envname}_auth_data: ${!envname_auth_data}"
    envname_commands_data="${envname}_commands_data"
    echo "${envname}_commands_data: ${!envname_commands_data}"
done
