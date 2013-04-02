{% for key in salt['data.load']() %}
    {% if key[:10] == "openstack." %}
        {% set res = salt['data.update'](key, None) %}
    {% endif %}
{% endfor %}
