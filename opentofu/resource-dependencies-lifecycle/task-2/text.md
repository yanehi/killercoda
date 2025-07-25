# Implicit

Terraform automatically discovers resource dependencies by analyzing resource attributes. These dependencies are typically declared through expression references, using interpolation syntax. When one resource property references another resource’s property or output, Terraform is able to determine the correct order of operations without additional configuration.

```hcl
resource "aws_instance" "example_a" {​
  ami           = data.aws_ami.amazon_linux.id​
  instance_type = "t2.micro"​
}​

resource "aws_eip" "ip" {​
  vpc      = true​
  instance = aws_instance.example_a.id​
}
```