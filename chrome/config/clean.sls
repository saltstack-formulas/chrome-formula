# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chrome with context %}

{%- if 'config' in chrome and chrome.config %}
    {%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

chrome-config-clean-file-absent:
  file.absent:
    - name: {{ chrome.environ_file }}
    - require:
      - sls: {{ sls_package_clean }}

{%- endif %}
