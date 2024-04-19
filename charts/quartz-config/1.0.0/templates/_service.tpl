{{- define "quartz.service" -}}
service:
  quartz:
    enabled: true
    primary: true
    type: NodePort
    targetSelector: quartz
    ports:
      webui:
        enabled: true
        primary: true
        port: {{ .Values.quartzNetwork.webPort }}
        nodePort: {{ .Values.quartzNetwork.webPort }}        
        targetPort: 8080
        targetSelector: quartz
{{- end -}}