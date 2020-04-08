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
    - unless: test -d '/Applications/Google Chrome.app'

    {%- elif grains.os_family in ('RedHat', 'Debian', 'Suse') %}

chrome-package-install-pkg-installed-directurl-linux:
  pkg.installed:
    - sources:
      - google-chrome-stable: {{ chrome.pkg.directurl.source }}
    - skip_verify: true
    - reload_modules: true
    - onlyif: {{ chrome.pkg.use_upstream_package_directurl }}

    {%- elif grains.kernel|lower == 'linux' %}

chrome-package-install-pkg-installed-name-linux:
  pkg.installed:
    - name: chromium    {# chrome.pkg.name #}
    - reload_modules: true
  cmd.run:
    - name: snap install {{ chrome.pkg.name }}
    - onlyif: test -x /usr/bin/snap || test -x /usr/local/bin/snap
    - onfail:
       - pkg: chrome-package-install-pkg-installed-name-linux

    {%- endif %}
