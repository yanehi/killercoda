At times, the relationship between resources isn’t established through direct references alone. In these situations, you can use the `depends_on` attribute to explicitly define dependencies.

This should only be used when Tofu cannot automatically determine the correct order of resource creation, or when certain provisioning steps must occur before or after a specific resource is deployed.

```hcl
resource "aws_instance" "example" {​
  ami           = data.aws_ami.amazon_linux.id​
  instance_type = "t2.micro"​
  depends_on = [aws_s3_bucket.example]​
}
```

1. Open the task-1 folder in the terminal

```
cd ~/resource-dependencies-lifecycle/task-1
```{{exec}}

2. Check with the commands if the code is syntactic correctly

```
tofu validate
```{{exec}}

3. Fix the errors and check the plan:

```
tofu apply
```{{exec}}

When you click the `Check` button after completing the exercise, the solution for `task-<number>` will be generated in the corresponding `solution-<number>` folder.