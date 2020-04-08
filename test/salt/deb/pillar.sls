# -*- coding: utf-8 -*-
# vim: ft=yaml
---
chrome:
  environ:
    - dummy=dummy
  environ_file: /etc/default/chrome.sh
  pkg:
    name: google-chrome-stable
    use_upstream_package_directurl: true
    use_upstream_macapp: false
    use_upstream_package: false
    directurl:
      # debian
      source: https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
