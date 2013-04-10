{% import "openstack/canary/config.sls" as config with context %}
include:
    - openstack.canary.base

{{ config.package("canary-api") }}
