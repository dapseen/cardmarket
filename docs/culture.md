## Team and engineering practices

### Service ownership

- [ ] Assign one team as the service owner.
- [ ] Assign a technical owner and a product owner.
- [ ] Record the owners in Backstage and `CODEOWNERS`.
- [ ] Define who approves production changes.
- [ ] Define who answers security and cost questions.
- [ ] Define an escalation path.

Each production service must have an active owner. Do not use a person who has
left the team as an owner.

### Code review

- [ ] Protect the `main` branch.
- [ ] Require a pull request for each change.
- [ ] Require approval from a code owner.
- [ ] Require CI checks before merge.
- [ ] Use small pull requests.
- [ ] Use conventional pull request titles.
- [ ] Use squash merge for a clear release history.
- [ ] Require a security review for high-risk changes.

The author must not approve their own pull request.

### Engineering standards

- [ ] Define standards for Go, Docker, Kubernetes, and Terraform.
- [ ] Run formatting, linting, tests, and security checks in CI.
- [ ] Keep common standards in reusable CI workflows.
- [ ] Record architecture decisions in Architecture Decision Records (ADRs).
- [ ] Review exceptions at regular intervals.

Do not depend on undocumented team knowledge.

### Change and release management

- [ ] Assign an owner to each production change.
- [ ] State the risk and rollback procedure in the pull request.
- [ ] Use Release Please to create releases.
- [ ] Use a fixed image tag or digest in production.
- [ ] Define when engineers can deploy.
- [ ] Define an emergency change procedure.
- [ ] Notify affected teams before a high-risk change.
- [ ] Verify the service after each production deployment.

A release is not complete until the verification checks are successful.

### On-call and incident response

- [ ] Define primary and secondary on-call engineers.
- [ ] Define incident severity levels.
- [ ] Define an incident commander role.
- [ ] Define communication channels for incidents.
- [ ] Add a runbook to each actionable alert.
- [ ] Define when to notify product, security, and management teams.
- [ ] Run incident exercises at regular intervals.
- [ ] Write a blameless review after a serious incident.
- [ ] Track corrective actions to completion.

Do not page an engineer for an alert that has no required action.

### Runbooks and documentation

- [ ] Write runbooks for deployment, rollback, scaling, and recovery.
- [ ] Add commands that engineers can copy safely.
- [ ] State the expected result of each procedure.
- [ ] Add the owner and last review date to each runbook.
- [ ] Link runbooks from Backstage, Grafana, and PagerDuty.
- [ ] Test runbooks with an engineer who did not write them.

A runbook is valid only if another engineer can use it successfully.

### Service contracts and dependencies

- [ ] Record each service dependency.
- [ ] Assign an owner to each dependency.
- [ ] Define API compatibility and version rules.
- [ ] Define timeout, retry, and availability requirements.
- [ ] Notify consumers before a breaking change.
- [ ] Test failure of each important dependency.
- [ ] Record external vendor support contacts.

Do not make a breaking API change without an approved migration plan.

### Knowledge sharing and onboarding

- [ ] Create an onboarding guide.
- [ ] Give new engineers a safe test environment.
- [ ] Pair engineers during important production work.
- [ ] Rotate deployment and on-call responsibilities.
- [ ] Review architecture and runbooks with the team.
- [ ] Record important decisions and demonstrations.
- [ ] Remove access when an engineer leaves the team.

At least two engineers must know how to operate each critical component.

### Security collaboration

- [ ] Assign a security contact for the service.
- [ ] Perform threat modeling before production use.
- [ ] Define who reviews vulnerabilities.
- [ ] Define remediation times by severity.
- [ ] Record accepted risk with an owner and expiry date.
- [ ] Give engineers the minimum required access.
- [ ] Review production access at regular intervals.

Security is a shared engineering responsibility. It is not only the security
team's responsibility.

### Cost ownership

- [ ] Assign a team and cost center to each resource.
- [ ] Add ownership labels to cloud and Kubernetes resources.
- [ ] Give the service owner access to cost dashboards.
- [ ] Define cost budgets and alerts.
- [ ] Review cost changes during architecture reviews.
- [ ] Review unused resources at regular intervals.

The team that operates the service must understand its operating cost.

### Production approval

- [ ] Engineering has approved the design.
- [ ] Security has approved the remaining risks.
- [ ] Operations has approved the runbooks.
- [ ] Product has approved the SLOs.
- [ ] The on-call team is ready.
- [ ] The load, recovery, release, and rollback tests are successful.
- [ ] Each exception has an owner and an expiry date.