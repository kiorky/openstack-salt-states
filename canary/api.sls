{% import "openstack/canary/config.sls" as config with context %}
include:
    - openstack.nova.base

{{ config.package("canary-api") }}
