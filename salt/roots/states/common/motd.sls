---
{% if pillar.ddserver.version < 0.3 %}
{% set pdns_backend = "pdns-backend-pipe" %}
{% else %}
{% set pdns_backend = "pdns-backend-remote" %}
{% endif %}

common.motd:
  file.managed:
    - name: /etc/motd
    - source: salt://common/files/motd
    - template: jinja
    - context:
      pdns_backend: {{ pdns_backend }}
