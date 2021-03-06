---
common.apps:
  pkg.installed:
    - pkgs:
      - bash
      - screen
      - htop
      - vim-nox
      - git

      - libmysqlclient-dev 
      - python-dev
      - python-pip
      - python3-pip

  cmd.run:
    - name: pip install --upgrade setuptools
