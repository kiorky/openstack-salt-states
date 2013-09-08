#!/usr/bin/env bash
KEYSTONE_REGION="{{keystone_region}}"
unset SERVICE_TENANT
# managed via salt, do not edit
. /etc/openstack/functions.sh
# at initialisation, we use TOKEN/ENDPOInT rather regular auth !
. /etc/openstack/openstack.env.d/00_endpoint.sh
ds=""
envf=/etc/openstack/openstack.env.d/01_keystone_roles.sh
unset ADMIN_ROLE MEMBER_ROLE
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$ADMIN_ROLE" ]];then
    ADMIN_ROLE=$(get_id keystone role-create --name=admin )
    ds="ya"
    if [[ $? == 0 ]];then
        MEMBER_ROLE=$(get_id keystone role-create --name=Member )
        if [[ $? == 0 ]];then
            echo "export ADMIN_ROLE=$ADMIN_ROLE" > $envf
            echo "export MEMBER_ROLE=$MEMBER_ROLE" >> $envf
        else exit 255
        fi
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/01_keystone_admin.sh
unset ADMIN_TENANT ADMIN_USER
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$ADMIN_TENANT" ]];then
    ds="ya"
    ADMIN_TENANT=$(get_id keystone tenant-create --name={{tenant}})
    if [[ $? == 0 ]];then
        ADMIN_USER=$(get_id keystone user-create --name={{username}} --pass={{password}})
        if [[ $? == 0 ]];then
            keystone user-role-add --user-id $ADMIN_USER \
                --role-id $ADMIN_ROLE \
                --tenant-id $ADMIN_TENANT
            if [[ $? == 0 ]];then
                echo "export ADMIN_USER=$ADMIN_USER" > $envf
                echo "export ADMIN_TENANT=$ADMIN_TENANT" >> $envf
            else exit 255
            fi
        else exit 255
        fi
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/01_keystone_service.sh
unset SERVICE_TENANT
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$SERVICE_TENANT" ]];then
    ds="ya"
    # Service tenant.
    SERVICE_TENANT=$(get_id keystone tenant-create --name={{ service_tenant }} --description "Service Tenant")
    if [[ $? == 0 ]];then
        echo "export SERVICE_TENANT=$SERVICE_TENANT" > $envf
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/01_keystone_service_identity.sh
unset IDENTITY_SERVICE KEYTSONE_SERVICE
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$IDENTITY_SERVICE" ]];then
    ds="ya"
    IDENTITY_SERVICE=$(get_id keystone service-create --name=keystone  --type=identity --description="Identity Service")
    if [[ $? == 0 ]];then
        echo "export IDENTITY_SERVICE=$IDENTITY_SERVICE" > $envf
        echo "export KEYSTONE_SERVICE=$IDENTITY_SERVICE" >> $envf
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/01_keystone_service_nova.sh
unset NOVA_SERVICE NOVA_USER
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$NOVA_SERVICE" ]];then
    ds="ya"
    NOVA_SERVICE=$(get_id keystone service-create --name=nova --type=compute --description="NOVA Service")
    if [[ $? == 0 ]];then
        NOVA_USER=$(get_id keystone user-create --name={{nova_username}} --pass={{nova_password}} --tenant-id $SERVICE_TENANT)
        if [[ $? == 0 ]];then
            keystone user-role-add --user-id $NOVA_USER \
                --role-id $ADMIN_ROLE \
                --tenant-id $SERVICE_TENANT
            if [[ $? == 0 ]];then
                echo "export NOVA_USER=$NOVA_USER" > "$envf"
                echo "export NOVA_SERVICE=$NOVA_SERVICE" > $envf
            else exit 255
            fi
        else exit 255
        fi
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/01_keystone_service_cinder.sh
unset VOLUME_SERVICE VOLUME_USER CINDER_SERVICE CINDER_USER
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$VOLUME_SERVICE" ]];then
    ds="ya"
    VOLUME_SERVICE=$(get_id keystone service-create --name=cinder --type=volume --description="Volume Service")
    if [[ $? == 0 ]];then
        VOLUME_USER=$(get_id keystone user-create --name={{cinder_username}} --pass={{cinder_password}} --tenant-id $SERVICE_TENANT)
        if [[ $? == 0 ]];then
            keystone user-role-add --user-id $VOLUME_USER \
                --role-id $ADMIN_ROLE \
                --tenant-id $SERVICE_TENANT
            if [[ $? == 0 ]];then
                echo "export VOLUME_USER=$VOLUME_USER" > $envf
                echo "export VOLUME_SERVICE=$VOLUME_SERVICE" >> $envf
                echo "export CINDER_USER=$VOLUME_USER" >> $envf
                echo "export CINDER_SERVICE=$VOLUME_SERVICE" >> $envf
            else exit 255
            fi
        else exit 255
        fi
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/01_keystone_service_quantum.sh
unset QUANTUM_SERVICE NETWORK_SERVICE QUANTUM_USER QUANTUM_SERVICE
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$NETWORK_SERVICE" ]];then
    ds="ya"
    NETWORK_SERVICE=$(get_id keystone service-create --name=quantum --type=network --description="Network Service")
    if [[ $? == 0 ]];then
        NETWORK_USER=$(get_id keystone user-create --name={{quantum_username}} --pass={{quantum_password}} --tenant-id $SERVICE_TENANT)
        if [[ $? == 0 ]];then
            keystone user-role-add --user-id $NETWORK_USER \
                --role-id $ADMIN_ROLE \
                --tenant-id $SERVICE_TENANT
            if [[ $? == 0 ]];then
                echo "export NETWORK_SERVICE=$NETWORK_SERVICE" > $envf
                echo "export NETWORK_USER=$NETWORK_USER" >> $envf
                echo "export QUANTUM_SERVICE=$NETWORK_SERVICE" >> $envf
                echo "export QUANTUM_USER=$NETWORK_USER" >> $envf
            else exit 255
            fi
        else exit 255
        fi
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/01_keystone_service_glance.sh
unset GLANCE_SERVICE GLANCE_USER
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$GLANCE_SERVICE" ]];then
    ds="ya"
    GLANCE_SERVICE=$(get_id keystone service-create --name=glance --type=image --description="Glance Image Service")
    if [[ $? == 0 ]];then
        GLANCE_USER=$(get_id keystone user-create --name={{glance_username}} --pass={{glance_password}} --tenant-id $SERVICE_TENANT)
        if [[ $? == 0 ]];then
            keystone user-role-add --user-id $GLANCE_USER \
                --role-id $ADMIN_ROLE \
                --tenant-id $SERVICE_TENANT
            if [[ $? == 0 ]];then
                echo "export GLANCE_SERVICE=$GLANCE_SERVICE" > $envf
                echo "export GLANCE_USER=$GLANCE_USER" >> $envf
            else exit 255
            fi
        else exit 255
        fi
    else exit 255
    fi
fi

envf=/etc/openstack/openstack.env.d/02_keystone_project_{{project_tenant}}.sh
unset PROJECT_USER PROJECT_TENANT DEMO_USER DEMO_TENANT
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$PROJECT_TENANT" ]];then
    ds="ya"
    # Service tenant.
    PROJECT_TENANT=$(get_id keystone tenant-create --name={{ project_tenant }} --description "PROJECT {{project_tenant}} Tenant")
    if [[ $? == 0 ]];then
        PROJECT_USER=$(get_id keystone user-create --name={{project_user}} --pass={{project_password}})
        if [[ $? == 0 ]];then
            keystone user-role-add --user-id $PROJECT_USER \
                --role-id $MEMBER_ROLE \
                --tenant-id $PROJECT_TENANT
            if [[ $? == 0 ]];then
                echo "export PROJECT_TENANT=$PROJECT_TENANT" > $envf
                echo "export PROJECT_USER=$PROJECT_USER" >> $envf
                echo "export DEMO_TENANT=$PROJECT_TENANT" >> $envf
                echo "export DEMO_USER=$PROJECT_USER" >> $envf
            else exit 255
            fi
        else exit 255
        fi
    else exit 255
    fi
fi

{% for nova_ip in nova_ips %}
{% set nid=nova_ip.replace('/', '_') %}
unset NOVA_EP
envf=/etc/openstack/openstack.env.d/40_nova_{{nid}}.sh
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$NOVA_EP" ]];then
    ds="ya"
    NOVA_EP=$(get_id keystone endpoint-create --region $KEYSTONE_REGION --service-id $NOVA_SERVICE --publicurl   "http://{{nova_ip}}:{{nova_api_port}}/v1.1/\$(tenant_id)s" --adminurl    "http://{{nova_ip}}:{{nova_api_port}}/v1.1/\$(tenant_id)s" --internalurl "http://{{nova_ip}}:{{nova_api_port}}/v1.1/\$(tenant_id)s")
    if [[ $? == 0 ]];then
        echo "export NOVA_EP='$NOVA_EP'">$envf
    else exit 255
    fi
fi
{% endfor %}

{% for cinder_ip in cinder_ips %}
{% set nid=cinder_ip.replace('/', '_') %}
unset VOLUME_EP
envf=/etc/openstack/openstack.env.d/10_cinder_{{nid}}.sh
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$VOLUME_EP" ]];then
    ds="ya"
    VOLUME_EP=$(get_id keystone endpoint-create --region $KEYSTONE_REGION --service-id $VOLUME_SERVICE --publicurl "http://{{cinder_ip}}:{{cinder_api_port}}/v1/%(tenant_id)s" --adminurl "http://{{cinder_ip}}:{{cinder_api_port}}/v1/%(tenant_id)s" --internalurl "http://{{cinder_ip}}:{{cinder_api_port}}/v1/%(tenant_id)s")
    if [[ $? == 0 ]];then
        echo "export VOLUME_EP='$VOLUME_EP'">$envf
    else exit 255
    fi
fi
{% endfor %}

{% for keystone_ip in keystone_ips %}
{% set nid=keystone_ip.replace('/', '_') %}
unset KEYSTONE_EP
envf=/etc/openstack/openstack.env.d/20_keystone_{{nid}}.sh
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$KEYSTONE_EP" ]];then
    ds="ya"
    KEYSTONE_EP=$(get_id keystone endpoint-create --region $KEYSTONE_REGION --service-id $IDENTITY_SERVICE --publicurl 'http://{{keystone_ip}}:5000/v2.0' --adminurl 'http://{{keystone_ip}}:35357/v2.0' --internalurl 'http://{{keystone_ip}}:5000/v2.0')
    if [[ $? == 0 ]];then
        echo "export KEYSTONE_EP='$KEYSTONE_EP'">$envf
    else exit 255
    fi
fi
{% endfor %}

{% for glance_ip in glance_ips %}
{% set nid=glance_ip.replace('/', '_') %}
unset GLANCE_EP
envf=/etc/openstack/openstack.env.d/20_glance_{{nid}}.sh
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$GLANCE_EP" ]];then
    ds="ya"
    GLANCE_EP=$(get_id keystone endpoint-create --region $KEYSTONE_REGION --service-id $GLANCE_SERVICE --publicurl "http://{{glance_ip}}:{{glance_api_port}}" --adminurl "http://{{glance_ip}}:{{glance_api_port}}" --internalurl "http://{{glance_ip}}:{{glance_api_port}}")
    if [[ $? == 0 ]];then
        echo "export GLANCE_EP='$GLANCE_EP'">$envf
    else exit 255
    fi
fi
{% endfor %}

{% for quantum_ip in quantum_ips %}
{% set nid=quantum_ip.replace('/', '_') %}
unset NETWORK_EP
envf=/etc/openstack/openstack.env.d/30_quantum_{{nid}}.sh
if [[ -f "$envf" ]];then . "$envf";fi
if [[ -z "$NETWORK_EP" ]];then
    ds="ya"
    NETWORK_EP=$(get_id keystone endpoint-create --region $KEYSTONE_REGION --service-id $NETWORK_SERVICE --publicurl "http://{{quantum_ip}}:{{quantum_api_port}}" --adminurl "http://{{quantum_ip}}:{{quantum_api_port}}" --internalurl "http://{{quantum_ip}}:{{quantum_api_port}}")
    if [[ $? == 0 ]];then
        echo "export NETWORK_EP='$NETWORK_EP'">$envf
    else exit 255
    fi
fi
{% endfor %}

if [[ -n $ds ]];then
    echo 'changed="yes" comment="keystone configured"'
else
    echo 'changed="no" comment="keystone already configured"'
fi
