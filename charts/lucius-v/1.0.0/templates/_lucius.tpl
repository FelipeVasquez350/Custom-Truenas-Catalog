{{- define "lucius.workload" -}}
workload:
  lucius:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      containers:
        lucius:
          enabled: true
          primary: true
          tty: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.luciusRunAs.user }}
            runAsGroup: {{ .Values.luciusRunAs.group }}
            readOnlyRootFilesystem: false  
          {{ with .Values.luciusConfig.additionalEnvs }}
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

{{/* Persistence */}}
persistence:
  db:
    enabled: true
    type: {{ .Values.luciusStorage.db.type }}
    datasetName: {{ .Values.luciusStorage.db.datasetName | default "" }}
    hostPath: {{ .Values.luciusStorage.db.hostPath | default "" }}
    targetSelector:
      lucius:
        lucius:
          mountPath: /home/lucius/db
  tmp:
    enabled: true
    type: emptyDir
    targetSelector:
      lucius:
        lucius:
          mountPath: /tmp
  {{- range $idx, $storage := .Values.luciusStorage.additionalStorages }}
  {{ printf "lucius-%v" (int $idx) }}:
    {{- $size := "" -}}
    {{- if $storage.size -}}
      {{- $size = (printf "%vGi" $storage.size) -}}
    {{- end }}
    enabled: true
    type: {{ $storage.type }}
    datasetName: {{ $storage.datasetName | default "" }}
    hostPath: {{ $storage.hostPath | default "" }}
    targetSelector:
      lucius:
        lucius:
          mountPath: {{ $storage.mountPath }}
  {{- end }}
{{- end -}}