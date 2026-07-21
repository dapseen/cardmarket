## Nginx Update

- Updated the naming convention `myNginx` to `mynginx` to follow k8s naming convention for DNS
- Updated the nginx.yaml file to use the specific image tag `1.27`
- Updated the containerPort to use `80` since thats where nginx container runs on
- One replica of nginx instance is fine, unless there are extreme usecase, or we switch to ingress