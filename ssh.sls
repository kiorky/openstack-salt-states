{% set ssh = pillar.get("openstack", {}).get("ssh", {}) %}

{% if ssh %}
root:
    ssh_auth:
      - present
      - user: root
      - enc: {{ ssh.get("enc", "ssh-rsa") }}
      - names:
        - {{ pillar.get("openstack", {}).get("ssh", {}).get("key", None) }}
{% endif %}
