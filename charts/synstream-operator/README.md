# SynStream Operator

Kubernetes operator for managing SynStream Flow applications.

## Installation

### Add Helm Repository

```bash
helm repo add synstream https://charts.synstream.rtsinv.com
helm repo update
```
### Install

```bash
# Install with default settings
helm install synstream-operator ./charts/synstream-operator
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of operator pod replicas | `1` |
| `image.registry` | Container registry | `ghcr.io` |
| `image.repository` | Repository/organization name | `rootsinnovation` |
| `image.name` | Operator image name | `synstream-operator` |
| `image.tag` | Operator image tag | `v0.1.3` |
| `image.pullPolicy` | Image pull policy | `Always` |
| `imagePullSecrets` | Secrets for pulling images from private registries | `[]` |
| `nameOverride` | Override chart name | `""` |
| `fullnameOverride` | Override full resource names | `""` |
| `synstream.image.registry` | Default SynStream app registry | `ghcr.io` |
| `synstream.image.repository` | Default SynStream app repository | `rootsinnovation` |
| `synstream.image.name` | Default SynStream app image name | `synstream` |
| `synstream.image.tag` | Default SynStream app image tag | `v1.0.0` |
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.automount` | Auto-mount service account token | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Custom service account name | `""` |
| `podAnnotations` | Annotations to add to operator pods | `{}` |
| `podLabels` | Labels to add to operator pods | `{}` |
| `podSecurityContext` | Pod-level security context | `{}` |
| `securityContext` | Container-level security context | `{}` |
| `resources` | Resource limits and requests | `{}` |
| `livenessProbe.httpGet.path` | Liveness probe path | `/healthz` |
| `livenessProbe.httpGet.port` | Liveness probe port | `8081` |
| `livenessProbe.initialDelaySeconds` | Initial delay for liveness probe | `15` |
| `livenessProbe.periodSeconds` | Period for liveness probe | `20` |
| `readinessProbe.httpGet.path` | Readiness probe path | `/readyz` |
| `readinessProbe.httpGet.port` | Readiness probe port | `8081` |
| `readinessProbe.initialDelaySeconds` | Initial delay for readiness probe | `5` |
| `readinessProbe.periodSeconds` | Period for readiness probe | `10` |
| `volumes` | Additional volumes to mount | `[]` |
| `volumeMounts` | Additional volume mounts | `[]` |
| `metrics.enabled` | Enable metrics endpoint | `true` |
| `metrics.bindAddress` | Address and port for metrics server | `:8443` |
| `metrics.secureServing` | Serve metrics over HTTPS | `true` |
| `metrics.serviceMonitor.enabled` | Create Prometheus ServiceMonitor | `false` |
| `metrics.serviceMonitor.namespace` | Namespace for ServiceMonitor | `""` |
| `metrics.serviceMonitor.labels` | Additional labels for ServiceMonitor | `{}` |
| `metrics.serviceMonitor.annotations` | Additional annotations for ServiceMonitor | `{}` |
| `metrics.serviceMonitor.selector` | Label selector for Prometheus | `{}` |
| `metrics.serviceMonitor.interval` | How often Prometheus should scrape | `30s` |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout for metrics scraping | `10s` |
| `leaderElection.enabled` | Enable leader election | `true` |
| `rbac.enable` | Create RBAC resources | `true` |
| `env` | Additional environment variables | `[]` |
| `extraArgs` | Additional command-line arguments | `[]` |
| `extraVolumes` | Extra volumes to mount | `[]` |
| `extraVolumeMounts` | Extra volume mounts | `[]` |
| `nodeSelector` | Node selector for operator pod placement | `{}` |
| `tolerations` | Tolerations for operator pod scheduling | `[]` |
| `affinity` | Affinity rules for operator pod placement | `{}` |

## Troubleshooting

```bash
# Check operator status
kubectl get pods -l app.kubernetes.io/name=synstream-operator

# Check logs
kubectl logs -l app.kubernetes.io/name=synstream-operator -f

# Check license
kubectl get license 

# Check flows
kubectl get flows
```

## Uninstalling

```bash
helm uninstall synstream-operator

# Optional: Remove CRDs (this will delete all Flow/License resources)
kubectl delete crd flows.synstream.rtsinv.com licenses.synstream.rtsinv.com
```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.