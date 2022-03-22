# Terraform Setup

This repo is used to deploy the back end terraform S3 bucket and DynamoDB table for storing state and state locks. Other projects in the same aws account can use the bucket and table ids from the output to store state and lock files without creating new buckets and tables.

## Installing Terraform

Go to https://www.terraform.io/downloads and follow the instructions for your OS.

Confirm your installation by running
`terraform version`

(My output was `Terraform v1.1.7 on linux_amd64`)

## Installing AWS cli

Go to https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html and follow the instructions for your OS.

Confirm your installation by running
`aws --version`

(My output was `aws-cli/2.4.27 Python/3.8.8 Linux/5.4.0-104-generic exe/x86_64.ubuntu.20 prompt/off`)

## Add a Terraform IAM User

We need a programmatic access key and it will be useful having a separate user for Terraform instead of your personal access credentials.

Head to AWS console and create a new IAM user with administration permissions. Set it to use programmatic access keys and save the access key and secret access key somewhere safe (a password manager is a good idea).


## Deploying to AWS

To deploy your terraform setup to aws make sure your aws credentials are setup in `~/.aws/credentials`, if using a named profile you will need to run `export AWS_PROFILE=<profile_name>` before running these commands.

Comment out the backend block. We do this because terraform needs the bucket and dynamodb table set up before we can store the state and lock files in aws.
Run:
`terraform init`
`terraform plan`
`terraform apply`

If you run into any issues with creating the bucket please note that bucket names must be unique in an aws region over all users. Adjust the bucket naming to suit.

Your bucket and dynamodb should now be created.

Now uncomment the backend block. Enter your bucket name, dynamodb table, key, and region. These must be hardcoded as terraform doesn't allow these to be variables.

Run:
`terraform plan`
`terraform apply`

Now your state and lock files are stored in aws. You can now set up other projects using the bucket, dynamodb table, and region while changing the key (something like <project_name>/terraform.tfstate) in a terraform backend block like in this repo.
