Hello World !



``` 
Example: create a pull secret for private GHCR images, then uncomment
imagePullSecrets in k8s/cardmarket.yaml.

kubectl create namespace cardmarket

kubectl create secret docker-registry ghcr-credentials \
  --namespace=cardmarket \
  --docker-server=ghcr.io \
  --docker-username=username \
  --docker-password=GITHUB_PAT \
  --docker-email=email
  
  ```
