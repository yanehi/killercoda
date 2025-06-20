# Task 3: Managing Docker Resources

In this task, you will:
- Define a Docker image resource (e.g., nginx)
- Define a Docker container resource using the image
- Plan and apply your configuration

## Steps
1. Add the following to your `main.tf`:
   ```hcl
   resource "docker_image" "nginx" {
     name = "nginx:latest"
   }
   
   resource "docker_container" "nginx" {
     image = docker_image.nginx.image_id
     name  = "tutorial-nginx"
     ports {
       internal = 80
       external = 8080
     }
   }
   ```
2. Run `tofu plan` to see what will be created.
3. Run `tofu apply` to create the resources.
4. Check running containers with `docker ps`.

**Tip:** You can access nginx at `http://localhost:8080` if ports are mapped. 