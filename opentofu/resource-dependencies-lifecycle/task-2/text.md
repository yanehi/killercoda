## Foreword

Tofu automatically discovers resource dependencies by analyzing resource attributes. These dependencies are typically declared through expression references, using interpolation syntax. When one resource property references another resource’s property or output, Tofu is able to determine the correct order of operations without additional configuration.

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

## Steps

1. Open the task-2 folder in the terminal

```
cd ~/resource-dependencies-lifecycle/task-2
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