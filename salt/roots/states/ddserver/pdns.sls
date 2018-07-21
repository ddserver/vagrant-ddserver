---
# Create ddserver recursor configuration,
# and add a ddserver example zone with appropriate SOA
# and NS records, using the pdns simplebind backend
#
ddserver.recursor:
  file.managed:
    - name: /etc/powerdns/pdns.d/pdns.ddserver.conf
    {% if pillar.ddserver.version < 0.3 %}
    - source: salt://ddserver/files/pdns.ddserver_pipe.conf
    {% else %}
    - source: salt://ddserver/files/pdns.ddserver_remote.conf
    {% endif %}
    - user: root
    - group: root
    - mode: 644

ddserver.bindbackend:
  file.managed:
    - name: /etc/powerdns/bindbackend.conf
    - source: salt://ddserver/files/bindbackend.conf
    - user: root
    - group: root
    - mode: 644

ddserver.zone:
  file.managed:
    - name: /etc/powerdns/zones/example.org.zone
    - source: salt://ddserver/files/example.org.zone
    - user: root
    - group: root
    - mode: 644
    - makedirs: True