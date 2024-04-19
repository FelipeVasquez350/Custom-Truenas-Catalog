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
            runAsNonRoot: false
            readOnlyRootFilesystem: false              
            allowPrivilegeEscalation: true
            capabilities:
              add:
                - FOWNER
                - DAC_OVERRIDE
                - CHOWN
                - SETUID
                - SETGID
                - SETFCAP
                - SETPCAP
                - SYS_ADMIN
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