{{/*
Expand the name of the chart.
*/}}
{{- define "synstream-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "synstream-manager.fullname" -}}
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
{{- define "synstream-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "synstream-manager.labels" -}}
helm.sh/chart: {{ include "synstream-manager.chart" . }}
{{ include "synstream-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "synstream-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "synstream-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "synstream-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "synstream-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build manager image URL
*/}}
{{- define "synstream-manager.imageURL" -}}
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
Build manager image tag
*/}}
{{- define "synstream-manager.imageTag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Service name - allows customization
*/}}
{{- define "synstream-manager.serviceName" -}}
{{- .Values.service.name | default (printf "%s-service" (include "synstream-manager.fullname" .)) }}
{{- end }}