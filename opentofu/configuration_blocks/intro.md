# Syntax and configuration blocks

## Foreword

In this scenario, you will learn the fundamentals of developing OpenTofu configuration files. 
The elementary building blocks will be introduced, their functionality explained in detail, and their usage demonstrated in the context of a simple Docker-hosted web server. 
The following building blocks will be covered:
- `provider`
- `resource`
- `variable`
- `locals`
- `output`
The `data` block type will not be covered, as there is no appropriate data source available for this scenario within the used provider.
If you are interested in using `data` blocks, information can be found on the [Data Source Documentation page](https://opentofu.org/docs/language/data-sources/).

## Prerequisites
- Basic command-line knowledge in Ubuntu
- Familiarity with Docker concepts (containers, images)

## Install Terraform Plugin for syntax highlighting

![Install Terraform Plugin for syntax highlighting](./assets/terraform_plugin.png)

> **_CAUTION:_** Please wait until the environment is fully prepared before starting the exercise (`Start` button). You can monitor the preparation status in the terminal on the right side.
