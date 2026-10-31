{{- define "pihole.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "pihole.fullname" -}}
{{- if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "pihole.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{ include "pihole.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "pihole.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pihole.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "pihole.secretName" -}}
{{- .Values.admin.existingSecret | default (printf "%s-admin" (include "pihole.fullname" .)) }}
{{- end }}

{{- define "pihole.claimName" -}}
{{- .Values.persistence.existingClaim | default (include "pihole.fullname" .) }}
{{- end }}

{{- define "pihole.dnsHosts" -}}
{{- $entries := list }}
{{- range . }}
{{- $entries = append $entries (printf "%s %s" .ip .host) }}
{{- end }}
{{- join ";" $entries }}
{{- end }}
