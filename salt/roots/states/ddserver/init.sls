---
# Clone the ddserver repo
#
ddserver-repo:
  git.latest:
    - name: {{ pillar.ddserver.repo }} 
    - rev: {{ pillar.ddserver.branch }}
    - target: /usr/local/src/ddserver
    - require:
      - pkg: common.apps
      - git: mysql_connector


# Create the ddserver logfile
#
ddserver.logfile:
  file.managed:
    - name: /var/log/ddserver.log
    - user: root
    - group: www-data
    - mode: 777


# If a ddserver version prior to 0.3 is being deployed, just install
# using setuptools, create an init script, and start the service.
#
{% if pillar.ddserver.version < 0.3 %}
ddserver:
  cmd.run:
    - name: {{ pillar.ddserver.python }} setup.py install
    - cwd: /usr/local/src/ddserver

ddserver.config:
  file.symlink:
    - name: /etc/ddserver/ddserver.conf
    - target: /etc/ddserver/ddserver.conf.example

ddserver.service:
  file.managed:
    - name: /etc/systemd/system/ddserver-bundle.service
    - source: salt://ddserver/files/ddserver-bundle.service
    - mode: 644
    - user: root
    - group: root

  service.running:
    - name: ddserver-bundle
    - enable: True


# If ddserver version >= 0.3 is being deployed, create a virtualenv,
# install ddserver into the venv, and run it as a WSGI application
# using the apache2 webserver.
#
{% else %}

include:
  - apache2

/opt/ddserver:
  pkg.installed:
    - name: virtualenv

  virtualenv.managed:
    - system_site_packages: False
    - python: /usr/bin/{{ pillar.ddserver.python }}
    - no_chown: True

  cmd.run:
    - name: |
        cd /opt/ddserver
        source ./bin/activate
        pip install setuptools --upgrade
        cd /usr/local/src/ddserver
        python setup.py install


ddserver.config:
  file.directory:
    - name: /etc/ddserver

  cmd.run:
    - name: |
        ln -s $(/opt/ddserver/bin/python -c 'import os; import ddserver; print(os.path.dirname(ddserver.__file__))')/resources/doc/ddserver.conf.example /etc/ddserver/ddserver.conf


/etc/ddserver/ddserver.wsgi:
  cmd.run:
    - name: |
        ln -s $(/opt/ddserver/bin/python -c 'import os; import ddserver; print(os.path.dirname(ddserver.__file__))')/resources/doc/ddserver.wsgi /opt/ddserver/


/etc/apache2/sites-available/default.conf:
  file.managed:
    - source: salt://ddserver/files/default-vhost.conf
    - require:
      - pkg: apache2
    - require_in:
      - file: /etc/apache2/sites-available

  cmd.run:
    - name: |
        a2ensite default
        systemctl reload apache2

{% endif %}
