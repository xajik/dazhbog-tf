# Dazhbod Terraform 

![alt text](img/img.png)

## TF Init

* From: https://gitlab.com/ `user` / `project` /-/terraform
    * TF_ADDRESS = https://gitlab.com/api/v4/projects/`project id`/terraform/state/`state name`
    * TF_USERNAME = `user name from gitlab`
    * TF_PASSWORD = `access token from gitlab user profile, not project`

``` 
terraform init -reconfigure \
        -backend-config="address=${TF_ADDRESS}" \ 
        -backend-config="lock_address=${TF_ADDRESS}/lock" \
        -backend-config="unlock_address=${TF_ADDRESS}/lock" \
        -backend-config="username=${TF_USERNAME}" \
        -backend-config="password=${TF_PASSWORD}" \
        -backend-config="lock_method=POST" \
        -backend-config="unlock_method=DELETE" \
        -backend-config="retry_wait_min=5"
```

## TF Lock 

Profide lock for Mac for local developemtn and linux for remote

* terraform providers lock \
    -platform=darwin_amd64 \
    -platform=linux_amd64 \
    -platform=darwin_arm64 \
    -platform=linux_arm64

## Track

Track required permissions

* https://github.com/iann0036/iamlive 
    * export AWS_CSM_ENABLED=true
    * iamlive --set-ini --profile gitlab-ci-cd --output-file policy.json

## State

* Use gitlab state maangement https://docs.gitlab.com/ee/user/infrastructure/iac/gitlab_terraform_helpers.html 

## AWS CLI 

* aws configure list-profiles
* aws sts get-caller-identity --profile=

## Errors

* Cannot link service role
    * If it is first role in new accoutn: aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com 