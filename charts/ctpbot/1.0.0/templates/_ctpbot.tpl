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
          initContainers:
          {{- include "ix.v1.common.app.permissions" (dict "containerName" "01-permissions"
                                                        "UID" .Values.ctpbotRunAs.user
                                                        "GID" .Values.ctpbotRunAs.group
                                                        "mode" "check"
                                                        "type" "init") | nindent 8 }}

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
        01-permissions:
          mountPath: /mnt/directories/bot/archive
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
        01-permissions:
          mountPath: /mnt/directories{{ $storage.mountPath }}
  {{- end }}
{{- end -}}