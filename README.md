# AWS Terraform Playground

Terraform example scripts to provision AWS Batch simple job queue.

## Try to provision

```sh
export AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
cd provision
terraform init
terraform plan
terraform apply
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
```

## Run A Simple Job

```sh
aws batch submit-job --job-name "simple-job-try" --job-queue "${JOB_QUEUE_ARN}" --job-definition "${JOB_DEFINITION_ARN}" --region ap-northeast-1
```

Confirm `${JOB_QUEUE_ARN}` and `${JOB_DEFINITION_ARN}` with `terraform show`.

# License

Copyright [Takashi AOKI][tak.sh]

Licensed under the [Apache License, Version 2.0][apache-license-2.0].

[tak.sh]: https://tak.sh
[apache-license-2.0]: http://www.apache.org/licenses/LICENSE-2.0.html
