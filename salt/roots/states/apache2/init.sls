---
apache2:
  pkg.installed:
    - pkgs:
      - apache2
{% if pillar.ddserver.python.startswith('python2') %}
      - libapache2-mod-wsgi
{% else %}
      - libapache2-mod-wsgi-py3
{% endif %}

  service.running:
    - enable: True
    - watch:
      - file: /etc/apache2/ports.conf


/etc/apache2/ports.conf:
  file.managed:
    - source: salt://apache2/files/ports.conf


/etc/apache2/sites-available:
  file.directory:
    - clean: True
    - makedirs: True

/etc/apache2/sites-enabled:
  file.directory:
    - clean: True
    - makedirs: True

