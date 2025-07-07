# SynStream Operator

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A Helm chart for SynStream Operator - Kubernetes operator for managing SynStream flows

## Description

The SynStream Operator manages SynStream Flow resources in Kubernetes, providing declarative management of Node-RED based IoT flow development environments.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installation

### Add Helm Repository

```bash
helm repo add rootsinnovation https://rootsinnovation.github.io/helm-charts
helm repo update
```

### Install the Chart

```bash
# Basic installation
helm install synstream-operator rootsinnovation/synstream-operator

# Install in specific namespace
helm install synstream-operator rootsinnovation/synstream-operator \
  --namespace synstream-system --create-namespace

# Custom configuration
helm install synstream-operator rootsinnovation/synstream-operator \
  --set synstream.image.tag=v2.0.0 \
  --set metrics.serviceMonitor.enabled=true
```

## Configuration

### Key Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of operator replicas | `1` |
| `image.registry` | Container registry | `ghcr.io` |
| `image.repository` | Image repository | `rootsinnovation` |
| `image.name` | Image name | `synstream-operator` |
| `image.tag` | Image tag | `v0.1.0` |
| `synstream.image.registry` | Default SynStream registry | `ghcr.io` |
| `synstream.image.repository` | Default SynStream repository | `rootsinnovation` |
| `synstream.image.name` | Default SynStream image name | `synstream` |
| `synstream.image.tag` | Default SynStream image tag | `v1.0.0` |

### Metrics Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `metrics.enabled` | Enable metrics endpoint | `true` |
| `metrics.bindAddress` | Metrics bind address | `:8443` |
| `metrics.serviceMonitor.enabled` | Create ServiceMonitor | `false` |

### Security Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `rbac.create` | Create RBAC resources | `true` |
| `serviceAccount.create` | Create service account | `true` |
| `crds.install` | Install CRDs | `true` |

## Examples

### Production Setup

```yaml
# values-prod.yaml
image:
  tag: "v0.1.0"

synstream:
  image:
    tag: "v1.0.0"

resources:
  limits:
    cpu: 500m
    memory: 128Mi
  requests:
    cpu: 10m
    memory: 64Mi

metrics:
  serviceMonitor:
    enabled: true

securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop: [ALL]
  runAsNonRoot: true
  runAsUser: 65532
```

### Private Registry

```yaml
image:
  registry: harbor.mycompany.com
  repository: platform
  name: synstream-operator

synstream:
  image:
    registry: harbor.mycompany.com
    repository: platform
    name: synstream

imagePullSecrets:
  - name: harbor-secret
```

## Usage

After installation, create Flow resources:

```yaml
apiVersion: synstream.rtsinv.com/v1
kind: Flow
metadata:
  name: my-flow
spec:
  image:
    url: ghcr.io/rootsinnovation/synstream
    tag: v1.0.0
  replicas: 1
  service:
    type: ClusterIP
    port: 1880
```

## Uninstalling

```bash
helm uninstall synstream-operator
```

## Support

- [GitHub Issues](https://github.com/RootsInnovation/synstream-operator/issues)
- [Documentation](https://github.com/RootsInnovation/synstream-operator)
