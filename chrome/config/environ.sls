# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chrome with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if chrome.environ or chrome.config.path %}

    {%- if chrome.pkg.use_upstream_source %}
        {%- set sls_package_install = tplroot ~ '.source.install' %}
    {%- elif chrome.pkg.use_upstream_archive %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.package.install' %}
    {%- endif %}
include:
  - {{ sls_package_install }}

chrome-config-file-managed-environ_file:
  file.managed:
    - name: {{ chrome.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='chrome-config-file-managed-environ_file'
                 )
              }}
    - mode: 640
    - user: {{ chrome.rootuser }}
    - group: {{ chrome.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        path: {{ chrome.config.path|json }}
        environ: {{ chrome.environ|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
