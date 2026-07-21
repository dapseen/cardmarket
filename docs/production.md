# Production readiness

Use this checklist before you move Cardmarket to production. Record the
owner, target date, and evidence for each item. Do not approve production
use until all required items are complete.

## Application improvement

### Readiness probe

- [ ] Add a separate `/ready` endpoint.
- [ ] Make the endpoint return success only when the application can receive traffic
- [ ] Do not use the liveness endpoint as the readiness endpoint.
- [ ] Configure a startup probe if application startup can take a long time.
- [ ] Test probe failure during a deployment.

A readiness probe removes an unready pod from the Service. It does not restart
the pod.

### HPA - Horizontal Pod Autoscaler or KEDA

- [ ] Select HPA or KEDA from the scaling requirements.
- [ ] Use HPA for CPU, memory, or standard Kubernetes metrics.
- [ ] Use KEDA for event-driven workloads and external metrics.
- [ ] Install Metrics Server if HPA uses resource metrics.
- [ ] Set minimum and maximum replica counts.
- [ ] Set scale-up and scale-down rules.
- [ ] Test scaling with a controlled load test.
- [ ] Make sure that the cluster has capacity for the maximum replica count.

Do not install KEDA only to scale a basic HTTP service. Start with HPA unless
the application needs event-driven scaling.

### Secret management - ESO

- [ ] Install External Secrets Operator (ESO).
- [ ] Select an external secret store.
- [ ] Use workload identity instead of static cloud access keys.
- [ ] Store GHCR and application secrets outside Git.
- [ ] Set secret rotation intervals.
- [ ] Limit secret access with Kubernetes RBAC.
- [ ] Encrypt Kubernetes secrets at rest.
- [ ] Test secret rotation and secret store failure.

Do not store a production token in a manifest, a Helm values file, or a Git
repository.

### Memory and CPU management

- [ ] Measure CPU and memory use under normal and peak load.
- [ ] Set CPU and memory requests from measured values.
- [ ] Set limits that do not stop valid workloads.
- [ ] Review throttling and out-of-memory events.
- [ ] Configure a LimitRange for default namespace values.
- [ ] Configure a ResourceQuota for the namespace.
- [ ] Test the application at its resource limits.

Requests control scheduling. Limits control the maximum resource use. Very low
CPU limits can increase latency because of CPU throttling.

### Network Policy

- [ ] Use a network plug-in that enforces NetworkPolicy.
- [ ] Deny ingress and egress traffic by default.
- [ ] Permit ingress only from the Ingress Controller.
- [ ] Permit egress only to required services and DNS.
- [ ] Use namespace and pod labels with a clear ownership policy.
- [ ] Test allowed and denied network paths.

A NetworkPolicy has no effect if the cluster network plug-in does not enforce
it.

### mTLS - service-to-service communication

- [ ] Identify all internal service-to-service connections.
- [ ] Select a service mesh or another certificate system.
- [ ] Enable mutual TLS for internal traffic.
- [ ] Use a trusted certificate authority.
- [ ] Automate certificate issue and rotation.
- [ ] Define authorization rules after identity verification.
- [ ] Monitor certificate age and failed handshakes.
- [ ] Test certificate rotation without an outage.

Do not add a service mesh for one service only. The mesh adds resource use and
operational work. Add it when multiple services require identity, encryption,
and traffic policy.

## Infrastructure improvement



### High availability

- [ ] Use a production Kubernetes service or a multi-node cluster.
- [ ] Run control-plane components across failure domains.
- [ ] Run at least two application replicas.
- [ ] spread replicas across nodes and availability zones.
- [ ] Add a PodDisruptionBudget.
- [ ] Use topology spread constraints or pod anti-affinity.
- [ ] Make the Ingress Controller highly available.
- [ ] Remove single points of failure from DNS and load balancing.
- [ ] Test node, zone, pod, and network failure.

Minikube is for development and demonstrations. Do not use Minikube as the
production cluster.

### Disaster recovery - SLA,SLO and SLI

- [ ] Define the recovery time objective (RTO).
- [ ] Define the recovery point objective (RPO).
- [ ] Back up cluster state and persistent data.
- [ ] Store backups in a separate account or failure domain.
- [ ] Encrypt backups.
- [ ] Define backup retention and deletion rules.
- [ ] Keep infrastructure and application configuration in Git.
- [ ] Document the restore procedure.
- [ ] restore a backup in a test environment.
- [ ] Run a disaster recovery exercise at regular intervals.

A backup is not sufficient until a restore test is successful.

## GitOps



### Introduce Argo CD for deployment and rollback management

- [ ] Install Argo CD with high availability settings.
- [ ] Put the desired Kubernetes state in a Git repository.
- [ ] Separate application source from environment configuration.
- [ ] Give Argo CD the minimum required permissions.
- [ ] Protect production branches with review rules.
- [ ] Use automated synchronization only after tests are successful.
- [ ] Enable drift detection and notifications.
- [ ] Do not make manual production changes with `kubectl`.
- [ ] Roll back by reverting the Git change.
- [ ] Test synchronization failure and rollback.

Git is the source of truth. Argo CD applies the approved state from Git.

### Helm chart for application packaging

- [ ] Create a Helm chart for the Deployment, Service, and Ingress.
- [ ] Put common defaults in `values.yaml`.
- [ ] Put environment-specific values in separate files.
- [ ] Do not put secrets in Helm values.
- [ ] Pin the container image by release tag or digest.
- [ ] Add chart schema validation.
- [ ] Run `helm lint` in CI.
- [ ] Render and validate templates in CI.
- [ ] Give the chart and application separate version numbers.

Keep the chart small. Do not add a value for each Kubernetes field.

## Observability



### Grafana

- [ ] Create dashboards for traffic, errors, latency, and saturation.
- [ ] Show deployment versions on dashboards.
- [ ] Add links from alerts to dashboards and runbooks.
- [ ] Control dashboard changes through Git.
- [ ] Test access control for production data.



### Prometheus

- [ ] Add a `/metrics` endpoint to the application.
- [ ] Define a ServiceMonitor or PodMonitor.
- [ ] Record request rate, error rate, and duration.
- [ ] Record CPU, memory, restart, and replica metrics.
- [ ] Set metric retention and storage requirements.
- [ ] Prevent labels with an unlimited number of values.
- [ ] Test Prometheus failure and data recovery.



### Datadog

- [ ] Decide if Datadog replaces or supplements Prometheus and Grafana.
- [ ] Install the Datadog Agent with minimum permissions.
- [ ] Store the API key in the external secret store.
- [ ] Enable only required logs, metrics, traces, and integrations.
- [ ] Remove sensitive data before telemetry leaves the cluster.
- [ ] Set retention and cost limits.

Do not collect the same telemetry in two systems without a clear requirement.

### PagerDuty

- [ ] Connect only actionable alerts to PagerDuty.
- [ ] Define primary and secondary on-call schedules.
- [ ] Add a runbook to each page.
- [ ] Set escalation and acknowledgement rules.
- [ ] Test alerts during a controlled exercise.
- [ ] Review noisy alerts and remove alerts with no action.



### Monitoring and latency optimization

- [ ] Define service-level indicators (SLIs).
- [ ] Define service-level objectives (SLOs).
- [ ] Measure p50, p95, and p99 request latency.
- [ ] Monitor traffic, errors, latency, and saturation.
- [ ] Add distributed tracing if requests use multiple services.
- [ ] Profile the application before optimization.
- [ ] Load-test the expected peak traffic.
- [ ] Set latency budgets for each request stage.
- [ ] Use alerts based on user impact and error-budget use.

Do not optimize from assumptions. Use measurements from representative load.

## Platform enablement



### Backstage

- [ ] Add Cardmarket to the Backstage catalog.
- [ ] Assign an owner and lifecycle status.
- [ ] Link the repository, documentation, dashboards, alerts, and runbooks.
- [ ] Add production dependencies to the service catalog.
- [ ] Control catalog changes through pull requests.
- [ ] Measure usage, time to commit and time to onboard



### Self-service

- [ ] Create approved templates for new services and environments.
- [ ] Automate repository, CI, chart, dashboard, and alert creation.
- [ ] Add policy checks to each template.
- [ ] Give users minimum required permissions.
- [ ] Record each self-service operation in an audit log.
- [ ] Define support ownership for generated resources.

Self-service must use safe defaults. It must not bypass security or review
controls.

## FinOps



### Karpenter for autoscaling

- [ ] Use Karpenter only if the production cluster runs on a supported cloud.
- [ ] Define permitted instance families, sizes, zones, and capacity types.
- [ ] Set disruption budgets and consolidation rules.
- [ ] Protect critical workloads from unsafe node disruption.
- [ ] Test scale-up from insufficient cluster capacity.
- [ ] Monitor pending pods and node creation time.

Karpenter scales nodes. HPA and KEDA scale pods. These tools solve different
problems.

### Kubecost

- [ ] Install Kubecost or an equivalent cost tool.
- [ ] Allocate costs by namespace, workload, team, and environment.
- [ ] Add labels for owner, service, environment, and cost center.
- [ ] Set cost alerts and budgets.
- [ ] Review idle and overprovisioned resources.
- [ ] Compare requested resources with actual use.



### Node and storage management

- [ ] Select node pools for workload requirements.
- [ ] Define node update and replacement procedures.
- [ ] Set storage classes and expansion rules.
- [ ] Encrypt persistent storage.
- [ ] Define snapshot, backup, retention, and restore rules.
- [ ] Monitor node pressure, disk use, and volume capacity.
- [ ] Test node drain and volume recovery.
- [ ] Remove unused volumes and snapshots through an approved process.



### AWS Reserved Instances

- [ ] Use Reserved Instances or Savings Plans only after use is stable.
- [ ] Measure baseline compute use before purchase.
- [ ] Keep variable demand on flexible capacity.
- [ ] Review term, payment, region, and instance restrictions.
- [ ] Track reservation use and coverage.
- [ ] Assign a finance and engineering owner.

Do not buy a long commitment from a short test. This item applies only if the
production platform uses AWS.

## Security



### WAF

- [ ] Put a supported Web Application Firewall before the public Ingress.
- [ ] Enable managed rules for common web attacks.
- [ ] Add rate limits and request size limits.
- [ ] Start new rules in monitor mode when possible.
- [ ] Log blocked requests without sensitive data.
- [ ] Test valid traffic and known attack patterns.
- [ ] Define an emergency rule change procedure.

A WAF is one security layer. It does not replace secure application code,
authentication, or authorization.

### Docker scanning through CI/CD

- [ ] Scan the image during each pull request.
- [ ] Scan the final image before publication.
- [ ] Fail the pipeline for defined severity and exploitability levels.
- [ ] Generate a software bill of materials (SBOM).
- [ ] Sign the image and verify the signature before deployment.
- [ ] Pin base images and CI actions by digest where practical.
- [ ] Rebuild images when base-image fixes are available.
- [ ] Do not publish an image after a failed required scan.



### Vulnerability scanning

- [ ] Scan source dependencies and Go modules.
- [ ] Scan container images and Kubernetes manifests.
- [ ] Scan the running cluster for configuration errors.
- [ ] Enable secret scanning for the Git repository.
- [ ] Define remediation times by severity.
- [ ] Track accepted risk with an owner and expiry date.
- [ ] Rescan production images at regular intervals.
- [ ] Test the response procedure with a sample finding.

