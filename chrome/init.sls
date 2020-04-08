# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chrome with context %}
{%- set p = chrome.pkg %}

include:
             {%- if grains.os_family in ('MacOS',) %}
  -{{ ' .macapp' if p.use_upstream_macapp else ' .package' }}

             {%- else %}
  - .package

             {%- endif %}

