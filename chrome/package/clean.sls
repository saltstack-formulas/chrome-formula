# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chrome with context %}

    {%- if grains.os_family == 'MacOS' %}

chrome-package-clean-cmd-run-cask:
  cmd.run:
    - name: brew cask remove {{ chrome.pkg.name }}
    - runas: {{ chrome.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

    {%- elif grains.kernel|lower == 'linux' %}

chrome-package-clean-pkg:
  pkg.removed:
    - names:
      - {{ chrome.pkg.name }}
      - google-chrome-stable
    - reload_modules: true
  cmd.run:
    - name: snap remove {{ chrome.pkg.name }}
    - onlyif: test -x /usr/bin/snap || test -x /usr/local/bin/snap
    - onfail:
      - pkg: chrome-package-clean-pkg

    {%- endif %}
