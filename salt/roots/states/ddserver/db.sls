---

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
{% if pillar.ddserver.version < 0.3 %}
    - name: mysql -u root ddserver < /usr/share/doc/ddserver/schema.sql
{% else %}
    - name: mysql -u root ddserver < $(/opt/ddserver/bin/python -c 'import os; import ddserver; print(os.path.dirname(ddserver.__file__))')/resources/doc/schema.sql
{% endif %}
    - watch:
      - mysql_database: ddserver.db
    - require:
      - pkg: mysql
