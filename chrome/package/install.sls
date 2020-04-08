# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chrome with context %}

    {%- if grains.os_family == 'MacOS' %}

chrome-package-install-cmd-run-cask:
  cmd.run:
    - name: brew cask install {{ chrome.pkg.name }}
    - runas: {{ chrome.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

    {%- elif grains.os_family in ('RedHat', 'Debian', 'Suse') and chrome.pkg.use_upstream_package_directurl %}

chrome-package-install-pkg-installed-directurl-linux:
  pkg.installed:
    - sources:
      - {{ chrome.pkg.name }}: {{ chrome.pkg.directurl.source }}
    - reload_modules: true

    {%- elif grains.kernel|lower == 'linux' %}

chrome-package-install-pkg-installed-name-linux:
  pkg.installed:
    - name: chromium    {# chrome.pkg.name #}
    - reload_modules: true
  cmd.run:
    - name: snap install {{ chrome.pkg.name }}
    - onlyif: test -x /usr/bin/snap || test -x /usr/local/bin/snap
    - onfail:
       - pkg: chrome-package-install-pkg-installed

    {%- endif %}
