# SynStream Manager

This Helm chart deploys SynStream Manager, a service for managing SynStream flows and licenses in Kubernetes environments.

## Installation

### Add Helm Repository

```bash
helm repo add roots-innovation https://RootsInnovation.github.io/helm-charts
helm repo update
```
### Install

```bash
# Install with default settings
helm install synstream-manager roots-innovation/synstream-manager
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.registry` | Container registry | `ghcr.io` |
| `image.repository` | Image repository | `rootsinnovation` |
| `image.name` | Image name | `synstream-manager` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Image pull secrets | `[]` |
| `replicaCount` | Number of replicas | `1` |
| `nameOverride` | Override chart name | `""` |
| `fullnameOverride` | Override full resource names | `""` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `8080` |
| `service.targetPort` | Target port | `8080` |
| `service.name` | Service name | `synstream-manager-service` |
| `service.annotations` | Service annotations | `{}` |
| `config.host` | Bind host | `0.0.0.0` |
| `config.port` | Bind port | `8080` |
| `config.debugLevel` | Log level (debug, info, warn, error) | `info` |
| `config.verbose` | Enable verbose logging | `false` |
| `config.printConfigs` | Print configuration on startup | `false` |
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.automount` | Auto-mount service account token | `true` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Custom service account name | `""` |
| `rbac.create` | Create RBAC resources | `true` |
| `rbac.rules` | Custom RBAC rules | See values.yaml |
| `podSecurityContext` | Pod-level security context | `{}` |
| `securityContext` | Container-level security context | `{}` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `128Mi` |
| `livenessProbe.httpGet.path` | Liveness probe path | `/healthz` |
| `livenessProbe.httpGet.port` | Liveness probe port | `http` |
| `livenessProbe.initialDelaySeconds` | Initial delay for liveness probe | `30` |
| `livenessProbe.periodSeconds` | Period for liveness probe | `10` |
| `readinessProbe.httpGet.path` | Readiness probe path | `/healthz` |
| `readinessProbe.httpGet.port` | Readiness probe port | `http` |
| `readinessProbe.initialDelaySeconds` | Initial delay for readiness probe | `5` |
| `readinessProbe.periodSeconds` | Period for readiness probe | `5` |
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Tolerations | `[]` |
| `affinity` | Affinity rules | `{}` |
| `env` | Additional environment variables | `{}` |
| `envFrom` | Environment variables from ConfigMaps/Secrets | `[]` |
| `volumes` | Additional volumes | `[]` |
| `volumeMounts` | Additional volume mounts | `[]` |

## Troubleshooting

```bash
# Check operator status
kubectl get pods -l app.kubernetes.io/name=synstream-manager
kubectl describe pod -l app.kubernetes.io/name=synstream-manager


# Check logs
kubectl logs -l app.kubernetes.io/name=synstream-manager -f
```

## Uninstalling

```bash
helm uninstall synstream-manager
```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.