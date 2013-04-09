{% set source = pillar.get('openstack:canary:source', 'deb http://downloads.gridcentriclabs.com/packages/canary/folsom/ubuntu gridcentric') %}

{% macro package(name) %}
{{name}}:
    pkg:
        - latest
    pkgrepo.managed:
        - name: {{source}}
        - baseurl: {{source}}
        - humanname: canary
        - file: /etc/apt/sources.list.d/canary.list
    require:
        - pkgrepo: {{source}}
{% endmacro %}
