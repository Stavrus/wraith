nodejs:
  pkg:
    - installed

npm-repo:
  pkgrepo.managed:
    - ppa: chris-lea/node.js
    - require_in:
      - pkg: nodejs

npm-packages:
  npm.installed:
    - names:
      - bower
      - grunt-cli

npminstall:
  cmd.run:
    - name: npm install
    - cwd: /vagrant/static
    - require:
      - pkg: nodejs

bowerinstall:
  cmd.run:
    - name: bower install
    - cwd: /vagrant/static
    - user: vagrant
    - require:
      - npm: npm-packages




