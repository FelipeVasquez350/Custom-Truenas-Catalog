{{- define "quartz.workload" -}}
workload:
  quartz:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      containers:
        quartz:
          enabled: true
          primary: true
          tty: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.quartzRunAs.user }}
            runAsGroup: {{ .Values.quartzRunAs.group }}            
            readOnlyRootFilesystem: false              
          {{ with .Values.quartzConfig.additionalEnvs }}
          env:
            {{ range $env := . }}
            {{ $env.name }}: {{ $env.value }}
            {{ end }}
          {{ end }}
          probes:
            liveness:
              enabled: false
            readiness:
              enabled: false
            startup:
              enabled: false
{{- end -}}