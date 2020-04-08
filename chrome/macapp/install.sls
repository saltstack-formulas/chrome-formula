# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chrome with context %}

chrome-macos-app-install-curl:
  file.directory:
    - name: {{ chrome.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ chrome.dir.tmp }}/chrome-{{ chrome.version }} {{ chrome.pkg.macapp.source }}
    - unless: test -f {{ chrome.dir.tmp }}/chrome-{{ chrome.version }}
    - require:
      - file: chrome-macos-app-install-curl
      - pkg: chrome-macos-app-install-curl
    - retry: {{ chrome.retry_option }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
chrome-macos-app-install-checksum:
  module.run:
    - onlyif: {{ chrome.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ chrome.dir.tmp }}/chrome-{{ chrome.version }}
    - file_hash: {{ chrome.pkg.macapp.source_hash }}
    - require:
      - cmd: chrome-macos-app-install-curl
    - require_in:
      - macpackage: chrome-macos-app-install-macpackage
  file.absent:
    - name: {{ chrome.dir.tmp }}/chrome-{{ chrome.version }}
    - onfail:
      - module: chrome-macos-app-install-checksum

chrome-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ chrome.dir.tmp }}/chrome-{{ chrome.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: chrome-macos-app-install-curl
  file.append:
    - name: '/Users/{{ chrome.rootuser }}/.bash_profile'
    - text: 'export PATH=$PATH:/Applications/Chrome.app/Contents/MacOS/chrome'
    - require:
      - macpackage: chrome-macos-app-install-macpackage

    {%- else %}

chrome-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The Chrome macpackage is only available on MacOS

    {%- endif %}
