{% import "openstack/canary/config.sls" as config with context %}

{{ config.package("canary-api") }}
