# oci-redis-cluster
redis-cluster
https://github.com/oracle-quickstart/oci-redis.gitcluster


## 
OCIterraformOCI [here](https://github.com/oracle/oci-quickstart-prerequisites).

## terraform
github


    git clone https://github.com/ocitiger/oci-redis-cluster.git
    cd oci-redis-cluster/terraform
    ls

##
oci-redis-cluster/terraformterraform.tfvars,
tenancy_ocid = "ocid1.tenancy.oc1....."
user_ocid = "ocid1.user.oc1....."
fingerprint= "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
private_key_path = "/path/oci_api_key_public.pem"
region = "ap-seoul-1" # region
compartment_ocid = "ocid1.compartment.oc1....."
ssh_public_key="ssh-rsa AAA... ... xxx@localhost"

##  Terraform
6node`variables.tf``instance_count`.
rediscluster6node6


d to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

:

![](./images/0.terraform-init.png)

##  Terraform 
:

    terraform plan

:

![](./images/0.terraform-plan.png)

##  Terraform 
:

    terraform apply

You'll need to enter `yes` when prompted.
`yes`  
![](./images/0.terraform-apply-yes.png)




![](./images/0.terraform-apply.png)


terraformRedisIP

`ssh -i <the key you used> <public IP of the Redis instance>`

terraformcloud-initRediscloud-inityum update15
Redis/tmp/M.log,Redis:
![](./images/0.M.log.png)


Redisrediscluster

```
host `hostname -f` | awk '{ system("redis-trib check "  $4":6379")}'
```

![](./images/0.redis.png)

## OCIredis

![](./images/0.console.png)

## Terraform 
Redis

    terraform destroy

`yes`

![](./images/0.terraform-destroy-yes.png)

Redis

![](./images/0.terraform-destroy.png)




