{{/*
Expand the name of the chart.
*/}}
{{- define "synstream-console.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "synstream-console.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "synstream-console.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "synstream-console.labels" -}}
helm.sh/chart: {{ include "synstream-console.chart" . }}
{{ include "synstream-console.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: frontend
synstream.io/workload-type: deployment
{{- end }}

{{/*
Selector labels
*/}}
{{- define "synstream-console.selectorLabels" -}}
app.kubernetes.io/name: {{ include "synstream-console.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "synstream-console.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "synstream-console.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build console image URL
*/}}
{{- define "synstream-console.imageURL" -}}
{{- $registry := .Values.image.registry }}
{{- $repository := .Values.image.repository }}
{{- $name := .Values.image.name }}
{{- if $registry }}
{{- printf "%s/%s/%s" $registry $repository $name }}
{{- else }}
{{- printf "%s/%s" $repository $name }}
{{- end }}
{{- end }}

{{/*
Build console image tag
*/}}
{{- define "synstream-console.imageTag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Service name - allows customization
*/}}
{{- define "synstream-console.serviceName" -}}
{{- .Values.service.name | default (printf "%s-service" (include "synstream-console.fullname" .)) }}
{{- end }}

{{/*
ConfigMap name
*/}}
{{- define "synstream-console.configMapName" -}}
{{- printf "%s-config" (include "synstream-console.fullname" .) }}
{{- end }}

{{/* =============================================================================
Component-specific helpers
============================================================================= */}}

{{/*
Build component image URL
Usage: include "synstream.componentImageURL" (dict "component" .Values.nginx "global" .Values.global "defaultName" "nginx")
*/}}
{{- define "synstream.componentImageURL" -}}
{{- $registry := .component.image.registry | default .global.image.registry }}
{{- $repository := .component.image.repository | default .global.image.repository }}
{{- $name := .component.image.name | default .defaultName }}
{{- if $registry }}
  {{- if $repository }}
    {{- printf "%s/%s/%s" $registry $repository $name }}
  {{- else }}
    {{- printf "%s/%s" $registry $name }}
  {{- end }}
{{- else }}
  {{- if $repository }}
    {{- printf "%s/%s" $repository $name }}
  {{- else }}
    {{- $name }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Build component image tag
Usage: include "synstream.componentImageTag" (dict "component" .Values.nginx "default" "latest")
*/}}
{{- define "synstream.componentImageTag" -}}
{{- .component.image.tag | default .default }}
{{- end }}

{{/*
Build component image pull policy
Usage: include "synstream.componentImagePullPolicy" (dict "component" .Values.nginx "global" .Values.global)
*/}}
{{- define "synstream.componentImagePullPolicy" -}}
{{- .component.image.pullPolicy | default .global.image.pullPolicy | default "IfNotPresent" }}
{{- end }}

{{/*
Component common labels for Deployment
Usage: include "synstream.componentLabels" (dict "name" "nginx" "workloadType" "deployment" "Chart" .Chart "Release" .Release)
*/}}
{{- define "synstream.componentLabels" -}}
app: {{ .name }}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ .name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
synstream.io/workload-type: {{ .workloadType }}
{{- end }}

{{/*
Component selector labels
Usage: include "synstream.componentSelectorLabels" (dict "name" "nginx")
*/}}
{{- define "synstream.componentSelectorLabels" -}}
app: {{ .name }}
{{- end }}

{{/*
Component ServiceAccount name
Usage: include "synstream.componentServiceAccountName" (dict "component" .Values.nginx "name" "nginx")
*/}}
{{- define "synstream.componentServiceAccountName" -}}
{{- if .component.serviceAccount.create }}
{{- .component.serviceAccount.name | default (printf "synstream-%s" .name) }}
{{- else }}
{{- .component.serviceAccount.name | default "default" }}
{{- end }}
{{- end }}

{{/*
Global imagePullSecrets
*/}}
{{- define "synstream.imagePullSecrets" -}}
{{- if .Values.global.imagePullSecrets }}
{{- toYaml .Values.global.imagePullSecrets }}
{{- end }}
{{- end }}
