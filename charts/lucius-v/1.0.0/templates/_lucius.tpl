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
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.luciusRunAs.user }}
            runAsGroup: {{ .Values.luciusRunAs.group }}
            readOnlyRootFilesystem: false          
          {{ with .Values.luciusConfig.additionalEnvs }}
          envList:
            {{ range $env := . }}
            - name: {{ $env.name }}
              values: {{ $env.value }}
            {{ end }}
          {{ end }}
          probes:
            liveness:
              enabled: true
              type: exec
              command:
                - /bin/sh
                - -c
                - |
                  chmod +x /usr/local/bin/docker-healthcheck.sh && \
                  /usr/local/bin/docker-healthcheck.sh || exit 1
            readiness:
              enabled: true
              type: exec
              command:
                - /bin/sh
                - -c
                - |
                  chmod +x /usr/local/bin/docker-healthcheck.sh && \
                  /usr/local/bin/docker-healthcheck.sh || exit 1
            startup:
              enabled: true
              type: exec
              command:
                - /bin/sh
                - -c
                - |
                  chmod +x /usr/local/bin/docker-healthcheck.sh && \
                  /usr/local/bin/docker-healthcheck.sh || exit 1

{{/* Persistence */}}
persistence:
  archive:
    enabled: true
    type: {{ .Values.luciusStorage.archive.type }}
    datasetName: {{ .Values.luciusStorage.archive.datasetName | default "" }}
    hostPath: {{ .Values.luciusStorage.archive.hostPath | default "" }}
    targetSelector:
      lucius:
        lucius:
          mountPath: /db
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