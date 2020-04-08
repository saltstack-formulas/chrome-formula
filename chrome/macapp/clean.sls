# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chrome with context %}

chrome-macos-app-clean-files:
  file.absent:
    - names:
      - {{ chrome.dir.tmp }}
      - /Applications/Chrome.app

    {%- else %}

chrome-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The chrome macpackage is only available on MacOS

    {%- endif %}
