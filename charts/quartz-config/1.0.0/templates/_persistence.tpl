{{- define "quartz.persistence" -}}
persistence:
  content:
    enabled: true
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" .Values.quartzStorage.content) | nindent 4 }}
    targetSelector:
      quartz:
        quartz:
          mountPath: /usr/src/app/content
  tmp:
    enabled: true
    type: emptyDir
    targetSelector:
      quartz:
        quartz:
          mountPath: /tmp
  {{- range $idx, $storage := .Values.quartzStorage.additionalStorages }}
  {{ printf "quartz-%v:" (int $idx) }}
    enabled: true
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" $storage) | nindent 4 }}
    targetSelector:
      quartz:
        quartz:
          mountPath: {{ $storage.mountPath }}
  {{- end }}
{{- end -}}