# Explicit

At times, the relationship between resources isn’t established through direct references alone. In these situations, you can use the `depends_on` attribute to explicitly define dependencies.

This should only be used when Terraform cannot automatically determine the correct order of resource creation, or when certain provisioning steps must occur before or after a specific resource is deployed.

```hcl
resource "aws_instance" "example" {​
  ami           = data.aws_ami.amazon_linux.id​
  instance_type = "t2.micro"​
  depends_on = [aws_s3_bucket.example]​
}
```