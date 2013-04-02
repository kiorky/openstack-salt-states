{% import "openstack/config.sls" as config with context %}
{% set res = salt['data.update']('openstack.rabbitmq', config.internal_ip) %}
