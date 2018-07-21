---
base:
  '*':
    - common.upgrade
    - common.apps
    - common.motd

    - mysql
    - powerdns

    - ddserver.mysql_connector
    - ddserver
    - ddserver.db
    - ddserver.pdns
