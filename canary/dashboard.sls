{% import "openstack/canary/config.sls" as config with context %}
include:
    - openstack.horizon.base

{{ config.package("canary-horizon") }}
