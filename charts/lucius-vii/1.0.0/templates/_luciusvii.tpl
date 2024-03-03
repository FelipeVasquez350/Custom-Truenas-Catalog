{{- define "luciusvii.workload" -}}
workload:
  luciusvii:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      containers:
        luciusvii:
          enabled: true
          primary: true
          tty: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.luciusviiRunAs.user }}
            runAsGroup: {{ .Values.luciusviiRunAs.group }}
            readOnlyRootFilesystem: false  
          {{ with .Values.luciusviiConfig.additionalEnvs }}
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