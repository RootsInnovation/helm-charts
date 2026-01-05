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
