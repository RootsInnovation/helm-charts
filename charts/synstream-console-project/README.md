# SynStream Console (Umbrella Chart)

This Helm chart deploys the complete SynStream platform, including the frontend console, all backend services, nginx gateway, and optional Ingress for external access.

## Overview

This is an umbrella chart that deploys all SynStream components:

### Frontend (Deployment)
- **console**: Web frontend application (synstream-console-vite)

### Backend Services - StatefulSets (with persistent storage)
- **auth**: Authentication service with JWT and session management
- **ai**: AI CopilotKit backend service with multiple LLM provider support

### Backend Services - Deployments (stateless)
- **k8s-resource**: Kubernetes resource management service (requires ClusterRole)
- **reverse-proxy**: Reverse proxy service for external API routing
- **nginx**: API gateway and routing (LoadBalancer by default)

### Additional Resources
- **ingress**: Optional Ingress resource for external access
- ConfigMaps for each service
- ServiceAccounts and RBAC (ClusterRole for k8s-resource)
- Persistent storage for StatefulSets

## Installation

### Add Helm Repository

```bash
helm repo add roots-innovation https://RootsInnovation.github.io/helm-charts
helm repo update
```

### Quick Start - Install All Components

```bash
# Install with default settings (all components enabled)
helm install synstream-console roots-innovation/synstream-console

# Install with ImagePullSecret for private registry
helm install synstream-console roots-innovation/synstream-console \
  --set global.imagePullSecrets[0].name=ghcr-imagepullsecret
```

### Minimal Installation - Frontend Only

```bash
helm install synstream-console roots-innovation/synstream-console \
  --set auth.enabled=false \
  --set ai.enabled=false \
  --set k8sResource.enabled=false \
  --set reverseProxy.enabled=false \
  --set nginx.enabled=true \
  --set console.enabled=true
```

### Custom Installation with Values File

Create a `custom-values.yaml` file:

```yaml
global:
  imagePullSecrets:
    - name: ghcr-imagepullsecret

# Enable ingress for external access
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: console.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: console-tls
      hosts:
        - console.example.com

# Customize storage sizes
auth:
  storage:
    size: 2Gi

# Configure AI API keys
ai:
  secrets:
    create: true
    gemini0ApiKey: "your-gemini-api-key"
    openai0ApiKey: "your-openai-api-key"
```

Install with custom values:

```bash
helm install synstream-console roots-innovation/synstream-console -f custom-values.yaml
```

## Configuration

### Global Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.imagePullSecrets` | Image pull secrets for private registry | `[]` |
| `global.image.registry` | Default image registry | `ghcr.io` |
| `global.image.repository` | Default image repository | `rootsinnovation` |
| `global.image.pullPolicy` | Default image pull policy | `Always` |

### Console (Frontend)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `console.enabled` | Enable console frontend | `true` |
| `console.replicaCount` | Number of replicas | `1` |
| `console.image.name` | Image name | `synstream-console-vite` |
| `console.image.tag` | Image tag | `poc` |
| `console.service.type` | Service type | `ClusterIP` |
| `console.service.port` | Service port | `80` |
| `console.resources.limits.cpu` | CPU limit | `100m` |
| `console.resources.limits.memory` | Memory limit | `128Mi` |

### Nginx (Gateway)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nginx.enabled` | Enable nginx gateway | `true` |
| `nginx.replicaCount` | Number of replicas | `1` |
| `nginx.service.type` | Service type | `LoadBalancer` |
| `nginx.service.port` | Service port | `80` |
| `nginx.config.defaultConf` | Nginx configuration | See values.yaml |

### Auth Service (StatefulSet)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `auth.enabled` | Enable auth service | `true` |
| `auth.replicaCount` | Number of replicas | `1` |
| `auth.image.tag` | Image tag | `poc` |
| `auth.service.port` | Service port | `8080` |
| `auth.storage.enabled` | Enable persistent storage | `true` |
| `auth.storage.size` | Storage size | `1Gi` |
| `auth.config.jwtSecretKey` | JWT secret key (⚠️ change in production) | `your-secret-key-here-please-change-in-production` |
| `auth.resources.limits.cpu` | CPU limit | `500m` |
| `auth.resources.limits.memory` | Memory limit | `512Mi` |

### AI Service (StatefulSet)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ai.enabled` | Enable AI service | `true` |
| `ai.replicaCount` | Number of replicas | `1` |
| `ai.image.tag` | Image tag | `poc` |
| `ai.service.port` | Service port | `8000` |
| `ai.storage.enabled` | Enable persistent storage | `true` |
| `ai.storage.size` | Storage size | `1Gi` |
| `ai.secrets.create` | Create secrets for API keys | `false` |
| `ai.secrets.openai0ApiKey` | OpenAI API key | `""` |
| `ai.secrets.gemini0ApiKey` | Gemini API key | `""` |
| `ai.secrets.anthropic0ApiKey` | Anthropic API key | `""` |
| `ai.resources.limits.cpu` | CPU limit | `1000m` |
| `ai.resources.limits.memory` | Memory limit | `1Gi` |

### K8s Resource Service (Deployment)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `k8sResource.enabled` | Enable k8s resource service | `true` |
| `k8sResource.replicaCount` | Number of replicas | `2` |
| `k8sResource.image.tag` | Image tag | `poc` |
| `k8sResource.service.port` | Service port | `8080` |
| `k8sResource.rbac.create` | Create ClusterRole and binding | `true` |
| `k8sResource.resources.limits.cpu` | CPU limit | `500m` |
| `k8sResource.resources.limits.memory` | Memory limit | `512Mi` |

⚠️ **Security Note**: The k8s-resource service requires **ClusterRole** with extensive permissions to manage Kubernetes resources cluster-wide. Review security implications before deployment.

### Reverse Proxy Service (Deployment)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `reverseProxy.enabled` | Enable reverse proxy service | `true` |
| `reverseProxy.replicaCount` | Number of replicas | `2` |
| `reverseProxy.image.tag` | Image tag | `poc` |
| `reverseProxy.service.port` | Service port | `8090` |
| `reverseProxy.resources.limits.cpu` | CPU limit | `500m` |
| `reverseProxy.resources.limits.memory` | Memory limit | `512Mi` |

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable Ingress resource | `false` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.hosts` | Ingress hosts configuration | See values.yaml |
| `ingress.tls` | TLS configuration | See values.yaml |

## Architecture

### Component Communication

```
Internet → Ingress (optional)
    ↓
Nginx Gateway (LoadBalancer)
    ↓
    ├─→ /api/v2 → Auth Service (8080)
    ├─→ /api/v1 → K8s Resource Service (8080)
    ├─→ /api/v1/proxy → Reverse Proxy Service (8090)
    └─→ / → Console Frontend (80)
```

### Workload Types

Each component is labeled with `synstream.io/workload-type` for easy identification:

- **Deployments** (stateless):
  - `synstream-console-vite`
  - `synstream-nginx`
  - `synstream-k8s-resource`
  - `synstream-reverse-proxy`

- **StatefulSets** (with persistent storage):
  - `synstream-auth` (1Gi)
  - `synstream-ai` (1Gi)

## Storage Requirements

StatefulSets require persistent volume support:

- **Total Storage**: ~2Gi by default
- **Storage Class**: Uses default storage class (can be customized per component)
- **Access Mode**: ReadWriteOnce

To customize storage:

```yaml
auth:
  storage:
    size: 2Gi
    storageClass: "fast-ssd"

ai:
  storage:
    size: 5Gi
    storageClass: "standard"
```

## Security Considerations

### ⚠️ Production Deployment Checklist

Before deploying to production, ensure you:

1. **Change Secret Keys**:
   ```yaml
   auth:
     config:
       jwtSecretKey: "your-secure-random-key-here"
   ```

2. **Configure AI API Keys** (if using AI service):
   ```yaml
   ai:
     secrets:
       create: true
       gemini0ApiKey: "your-actual-api-key"
       openai0ApiKey: "your-actual-api-key"
   ```

3. **Review RBAC Permissions**: The k8s-resource service has ClusterRole with extensive permissions

4. **Enable TLS/HTTPS**: Configure Ingress with TLS certificates

5. **Configure ImagePullSecrets**: For private container registry access

6. **Adjust Resource Limits**: Based on your workload requirements

## Common Operations

### Selective Component Deployment

Enable only specific components:

```bash
# Only frontend + nginx + auth
helm install synstream-console roots-innovation/synstream-console \
  --set ai.enabled=false \
  --set k8sResource.enabled=false \
  --set reverseProxy.enabled=false
```

### Scaling Services

```bash
# Scale stateless deployments
helm upgrade synstream-console roots-innovation/synstream-console \
  --set k8sResource.replicaCount=5 \
  --set reverseProxy.replicaCount=3 \
  --reuse-values
```

### Accessing Services

With default LoadBalancer:

```bash
# Get nginx LoadBalancer IP
kubectl get svc synstream-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# Access the application
curl http://<EXTERNAL-IP>
```

With Ingress enabled:

```bash
# Access via domain name
curl https://console.example.com
```

Port forwarding for testing:

```bash
# Forward nginx service
kubectl port-forward svc/synstream-nginx 8080:80

# Access locally
open http://localhost:8080
```

## Troubleshooting

### Check All Components Status

```bash
# View all pods
kubectl get pods -l app.kubernetes.io/instance=synstream-console

# Check by workload type
kubectl get pods -l synstream.io/workload-type=deployment
kubectl get pods -l synstream.io/workload-type=statefulset

# View services
kubectl get svc -l app.kubernetes.io/instance=synstream-console
```

### View Logs

```bash
# All components
kubectl logs -l app.kubernetes.io/instance=synstream-console --all-containers=true

# Specific component
kubectl logs -l app=synstream-auth -f
kubectl logs -l app=synstream-connection -f
kubectl logs -l app=synstream-k8s-resource -f
```

### Check Storage

```bash
# View PVCs for StatefulSets
kubectl get pvc

# Check PVC status for specific service
kubectl get pvc -l app=synstream-auth
kubectl get pvc -l app=synstream-ai
```

### Debug Individual Components

```bash
# Describe pod
kubectl describe pod <pod-name>

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Access pod shell (if needed)
kubectl exec -it <pod-name> -- /bin/sh
```

## Upgrading

```bash
# Upgrade to new version
helm upgrade synstream-console roots-innovation/synstream-console

# Upgrade with new values
helm upgrade synstream-console roots-innovation/synstream-console -f new-values.yaml

# Rollback if needed
helm rollback synstream-console
```

## Uninstalling

```bash
helm uninstall synstream-console
```

⚠️ **Note**: Uninstalling will **not** automatically delete PersistentVolumeClaims. To remove them:

```bash
# List PVCs
kubectl get pvc

# Delete manually
kubectl delete pvc -l app=synstream-auth
kubectl delete pvc -l app=synstream-ai
```

## Support

For issues and questions:
- Repository: https://github.com/RootsInnovation/helm-charts
- Documentation: https://rtsinv.com

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
