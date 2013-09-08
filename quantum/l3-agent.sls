{% import "openstack/config.sls" as config with context %}
include:
    - openstack.quantum.base

/etc/quantum/l3_agent.ini:
    file.managed:
        - source: salt://openstack/quantum/l3_agent.ini
        - user: quantum
        - group: quantum
        - mode: 0600
        - template: jinja
        - context:
            debug: {{ config.debug }}
    require:
        - user: quantum
        - group: quantum

{{ config.package("quantum-l3-agent") }}
    service.running:
        - name: quantum-l3-agent
        - enable: True
        - watch:
            - pkg: quantum-l3-agent
            - file: /etc/quantum/quantum.conf
    require:
        - pkg: quantum-l3-agent
        - file: /etc/quantum/quantum.conf
