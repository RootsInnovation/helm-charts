{{/*
Expand the name of the chart.
*/}}
{{- define "synstream-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "synstream-operator.fullname" -}}
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
{{- define "synstream-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "synstream-operator.labels" -}}
helm.sh/chart: {{ include "synstream-operator.chart" . }}
{{ include "synstream-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "synstream-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "synstream-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "synstream-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "synstream-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the namespace for the resources
*/}}
{{- define "synstream-operator.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}


{{/*
Build operator image URL
*/}}
{{- define "synstream-operator.imageURL" -}}
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
Build operator image tag
*/}}
{{- define "synstream-operator.imageTag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Build SynStream default image URL
*/}}
{{- define "synstream-operator.defaultImageURL" -}}
{{- $registry := .Values.synstream.image.registry }}
{{- $repository := .Values.synstream.image.repository }}
{{- $name := .Values.synstream.image.name }}
{{- if $registry }}
{{- printf "%s/%s/%s" $registry $repository $name }}
{{- else }}
{{- printf "%s/%s" $repository $name }}
{{- end }}
{{- end }}

{{/*
Build SynStream default image tag
*/}}
{{- define "synstream-operator.defaultImageTag" -}}
{{- .Values.synstream.image.tag | default .Chart.AppVersion }}
{{- end }}