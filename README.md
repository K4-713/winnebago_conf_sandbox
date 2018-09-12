# winnebago_conf_sandbox
Screwing around with terraform and aws

These scripts are run in terraform locally: 
See https://www.terraform.io/intro/getting-started/install.html

## The Show So Far:
* Spins up a deploy box, installs the aws client,
and sets up a a deploy user with the ability to ssh into the deploy box.
* Spins up four s3 buckets that will eventually be useful.

Reminder:
    terraform init
    terraform validate
    terraform plan
    terraform apply
    terraform destroy


You will have to define all the interesting variables in a terraform.tfvars file
before this will work. This is most simply achieved by renaming the included
.example file and configuring to suit your needs.


## TODO next:
* Allow the deploy user to alter S3 files from the deploy server.
https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html


## Eventual goals:
* Approved deployers should be a list or map on this end
* Add to the deploy server:
** A deploy script that pulls code form a specified external git repo into
the s3 staging bucket (directory)
** A script that pushes whatever is in staged code, to either the test or
prod s3 buckets, based on user input.
** All deploy scripts to log actions to the log bucket
* Need reasonable strategy for test and prod-specific config-type files...
* Spin up cloudfront to serve the files out of the test and prod buckets.
* ...must research security practices around keeping cloudfront test not so
public.



