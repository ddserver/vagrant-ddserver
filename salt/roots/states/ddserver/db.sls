---
{% if pillar.ddserver.version < 0.3 %}
{% set ddserver_dir = "/usr/share/doc/ddserver" %}
{% else %}
{% set ddserver_dir = "/opt/ddserver/lib/python2.7/site-packages/ddserver*.egg/doc/db" %}
{% endif %}

# Create ddserver database, database user,
# and import the ddserver database schema
#
ddserver.db:
  mysql_database.present:
    - name: ddserver
    - require:
      - pkg: mysql

  mysql_user.present:
    - name: ddserver
    - password: YourDatabasePassword
    - host: localhost
    - require:
      - pkg: mysql

  mysql_grants.present:
    - grant: all privileges
    - database: ddserver.*
    - user: ddserver
    - require:
      - pkg: mysql

  cmd.run:
    - name: mysql -u root ddserver < {{ ddserver_dir }}/schema.sql
    - watch:
      - mysql_database: ddserver.db
    - require:
      - pkg: mysql
