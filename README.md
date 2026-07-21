# Cardmarket

Cardmarket is a small Go HTTP service. It listens on port `8001`.
The project builds a container image and stores it in GitHub Container
Registry (GHCR). Kubernetes runs the image in Minikube.

## Production Setup and Tradeoffs

I discussed tradeoffs, [production requirements](/docs/production.md) and also [engineering culture](/docs/culture.md)

## Updated Nginx and Script file

see here [Nginx](/k8s/changes.md) and [Shell](/shell/changes.md)



## Prerequisites

Install these tools on the host:

- Docker
- Minikube
- `kubectl`
- Git

Make sure that the user can run Docker commands. Make sure that `kubectl`
uses the correct cluster:

```bash
docker version - v29.6.2
minikube version -  v1.38.1
kubectl version --client - v1.36.2
kubectl config current-context - Minikube
```

The Kubernetes manifest pulls a private image from GHCR. Create a GitHub
personal access token with `read:packages` permission. Do not store this
token in Git.

## How to create Minikube

Create the cluster with the Docker driver:

```bash
minikube start --driver=docker
```

Make sure that the cluster is ready:

```bash
minikube status
kubectl get nodes
```

The node must have the `Ready` status.

## How to enable ingress

Enable the NGINX Ingress Controller:

```bash
minikube addons enable ingress
```

Make sure that the controller is ready:

```bash
kubectl get pods -n ingress-nginx
```

Wait until the controller pod has the `Running` status.

## How to deploy and access the app

First, create the namespace:

```bash
kubectl apply -f k8s/cardmarket.yaml
```

The first deployment can report an image pull error because the GHCR
secret does not exist. Create the secret:

```bash
kubectl create secret docker-registry ghcr-credentials \
  --namespace=cardmarket \
  --docker-server=ghcr.io \
  --docker-username=YOUR_GITHUB_USERNAME \
  --docker-password=YOUR_GITHUB_TOKEN \
  --docker-email=YOUR_EMAIL
```

Do not put the real token in a YAML file. Apply the manifest again:

```bash
kubectl apply -f k8s/cardmarket.yaml
kubectl rollout status deployment/cardmarket -n cardmarket
```

Check the resources:

```bash
kubectl get pods,service,ingress -n cardmarket
```

On the Minikube host, test the Ingress:

```bash
curl --resolve "cardmarket.example:80:$(minikube ip)" \
  http://cardmarket.example
```

To use the name on the Minikube host, add it to `/etc/hosts`:

```bash
echo "$(minikube ip) cardmarket.example" | sudo tee -a /etc/hosts
```

Then open `http://cardmarket.example`.

## How releases are created

Use Conventional Commit text in pull request titles:

- `fix:` creates a patch release.
- `feat:` creates a minor release.
- `feat!:` creates a major release.

Example:

```text
feat: add a health endpoint
```

Use squash merge to put one clear commit on `main`.

After a change enters `main`, Release Please creates or updates a release
pull request. This pull request updates `CHANGELOG.md` and
`.release-please-manifest.json`. Do not edit these files by hand.

When the release pull request enters `main`, Release Please creates a Git
tag such as `v0.3.0`. The Docker workflow receives this tag and pushes
these image tags to GHCR:

```text
ghcr.io/dapseen/cardmarket:0.3.0
ghcr.io/dapseen/cardmarket:0.3
```

A normal pull request merge also pushes the moving `main` image tag.

The GitHub repository must have these Actions secrets:

- `CR_PAT`: a token with `write:packages` permission
- `RELEASE_TOKEN`: a token that can create release pull requests and tags



## How to upgrade and roll back

Use a fixed release tag in `k8s/cardmarket.yaml`. Do not use `main` for a
stable deployment.

To upgrade, change the image tag:

```yaml
image: ghcr.io/dapseen/cardmarket:0.3.0
```

Apply the change and wait for the deployment:

```bash
kubectl apply -f k8s/cardmarket.yaml
kubectl rollout status deployment/cardmarket -n cardmarket
```

Check the rollout history:

```bash
kubectl rollout history deployment/cardmarket -n cardmarket
```

To return to the last revision:

```bash
kubectl rollout undo deployment/cardmarket -n cardmarket
kubectl rollout status deployment/cardmarket -n cardmarket
```

To return to a specified revision:

```bash
kubectl rollout undo deployment/cardmarket -n cardmarket --to-revision=2
```



## Architecture and trade-offs

The request path is:

```text
Client
  -> NGINX Ingress
  -> ClusterIP Service on port 80
  -> Go container on port 8001
```

The deployment uses these security controls:

- The container runs as user `10001`, not as root.
- The container cannot get more privileges.
- The container drops all Linux capabilities.
- The root file system is read-only.
- The pod uses the default runtime seccomp profile.
- The namespace enforces the restricted Pod Security Standard.
- CPU and memory limits reduce resource use.
- The Ingress limits the request rate and request body size.

This design is small and easy to operate. Minikube is suitable for local
development and demonstrations. It is not a high-availability production
cluster. One replica does not give application redundancy. The Ingress
uses HTTP and does not provide TLS. 

