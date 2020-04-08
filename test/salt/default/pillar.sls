# -*- coding: utf-8 -*-
# vim: ft=yaml
---
chrome:
  environ:
    - dummy=dummy
  environ_file: /etc/default/chrome.sh
  pkg:
    name: chrome
    use_upstream_package_directurl: false
    use_upstream_macapp: false
    use_upstream_package: true   # snap'able?
