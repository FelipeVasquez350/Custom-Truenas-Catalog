{{- define "ctpbot.workload" -}}
workload:
  ctpbot:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      containers:
        ctpbot:
          enabled: true
          primary: true
          tty: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.ctpbotRunAs.user }}
            runAsGroup: {{ .Values.ctpbotRunAs.group }}
            readOnlyRootFilesystem: false          
          {{ with .Values.ctpbotConfig.additionalEnvs }}
          envList:
            {{ range $env := . }}
            - name: {{ $env.name }}
              values: {{ $env.value }}
            {{ end }}
          {{ end }}
          probes:
            liveness:
              enabled: false
            readiness:
              enabled: false
            startup:
              enabled: false

{{/* Persistence */}}
persistence:
  archive:
    enabled: true
    type: {{ .Values.ctpbotStorage.archive.type }}
    datasetName: {{ .Values.ctpbotStorage.archive.datasetName | default "" }}
    hostPath: {{ .Values.ctpbotStorage.archive.hostPath | default "" }}
    targetSelector:
      ctpbot:
        ctpbot:
          mountPath: /bot/archive
  tmp:
    enabled: true
    type: emptyDir
    targetSelector:
      ctpbot:
        ctpbot:
          mountPath: /tmp
  {{- range $idx, $storage := .Values.ctpbotStorage.additionalStorages }}
  {{ printf "ctpbot-%v" (int $idx) }}:
    {{- $size := "" -}}
    {{- if $storage.size -}}
      {{- $size = (printf "%vGi" $storage.size) -}}
    {{- end }}
    enabled: true
    type: {{ $storage.type }}
    datasetName: {{ $storage.datasetName | default "" }}
    hostPath: {{ $storage.hostPath | default "" }}
    targetSelector:
      ctpbot:
        ctpbot:
          mountPath: {{ $storage.mountPath }}
  {{- end }}
{{- end -}}