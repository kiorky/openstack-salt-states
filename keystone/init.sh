#!/usr/bin/env bash

export SERVICE_TOKEN={{token}}
export SERVICE_ENDPOINT=http://{{public_ip}}:{{auth}}/v2.0

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}

# Admin tenant.
ADMIN_TENANT=$(get_id keystone tenant-create --name={{tenant}})
ADMIN_USER=$(get_id keystone user-create --name={{username}} --pass={{password}})
ADMIN_ROLE=$(get_id keystone role-create --name={{username}})
keystone user-role-add --user-id $ADMIN_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $ADMIN_TENANT

# Service tenant.
SERVICE_TENANT=$(get_id keystone tenant-create --name={{service_tenant}} --description "Service Tenant")

GLANCE_USER=$(get_id keystone user-create --name={{glance_username}} --pass={{glance_password}} --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $GLANCE_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT

NOVA_USER=$(get_id keystone user-create --name={{nova_username}} --pass={{nova_password}} --tenant-id $SERVICE_TENANT)
keystone user-role-add --user-id $NOVA_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT

# Keystone service.
KEYSTONE_SERVICE=$(get_id keystone service-create --name=keystone --type=identity --description="Keystone Identity Service")
keystone endpoint-create --region RegionOne --service-id $KEYSTONE_SERVICE \
    --publicurl "http://{{public_ip}}:{{port}}/v2.0" \
    --adminurl "http://{{public_ip}}:{{port}}/v2.0" \
    --internalurl "http://{{public_ip}}:{{port}}/v2.0"

# Nova service.
NOVA_SERVICE=$(get_id keystone service-create --name=nova --type=compute --description="Nova Compute Service")
keystone endpoint-create --region RegionOne --service-id $NOVA_SERVICE \
    --publicurl "http://{{nova_ip}}:{{nova_api_port}}/v1.1/\$(tenant_id)s" \
    --adminurl "http://{{nova_ip}}:{{nova_api_port}}/v1.1/\$(tenant_id)s" \
    --internalurl "http://{{nova_ip}}:{{nova_api_port}}/v1.1/\$(tenant_id)s"

# Volume service.
VOLUME_SERVICE=$(get_id keystone service-create --name=volume --type=volume --description="Nova Volume Service")
keystone endpoint-create --region RegionOne --service-id $VOLUME_SERVICE \
    --publicurl "http://{{cinder_ip}}:{{cinder_api_port}}/v1/\$(tenant_id)s" \
    --adminurl "http://{{cinder_ip}}:{{cinder_api_port}}/v1/\$(tenant_id)s" \
    --internalurl "http://{{cinder_ip}}:{{cinder_api_port}}/v1/\$(tenant_id)s"

# Image service.
GLANCE_SERVICE=$(get_id keystone service-create --name=glance --type=image --description="Glance Image Service")
keystone endpoint-create --region RegionOne --service-id $GLANCE_SERVICE \
    --publicurl "http://{{glance_ip}}:{{glance_api_port}}" \
    --adminurl "http://{{glance_ip}}:{{glance_api_port}}" \
    --internalurl "http://{{glance_ip}}:{{glance_api_port}}"
