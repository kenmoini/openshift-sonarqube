#!/bin/bash

## Default variables to use
export INTERACTIVE=${INTERACTIVE:="true"}
export OCP_HOST=${OCP_HOST:=""}
export OCP_CREATE_PROJECT=${OCP_CREATE_PROJECT:="true"}
export OCP_PROJECT_NAME=${OCP_PROJECT_NAME:="cicd-sonarqube"}
export ADMIN_USERNAME=${ADMIN_USERNAME:=""}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:=""}
export PERSIST_DATA=${PERSIST_DATA:="true"}

export POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE=${POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE:="10Gi"}
export POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT=${POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT:="2Gi"}
export POSTGRES_CONTAINER_CPU_LIMIT=${POSTGRES_CONTAINER_CPU_LIMIT:="2"}
export SONARQUBE_MEMORY_LIMIT=${SONARQUBE_MEMORY_LIMIT:="4Gi"}
export SONARQUBE_CPU_LIMIT=${SONARQUBE_CPU_LIMIT:="4"}
export SONARQUBE_PERSISTENT_VOLUME_SIZE=${SONARQUBE_PERSISTENT_VOLUME_SIZE:="10Gi"}
export FORCE_AUTHENTICATION=${FORCE_AUTHENTICATION:="false"}
# SONAR_AUTH_REALM: The type of authentication that SonarQube should be using (None or LDAP) (Ref - https://docs.sonarqube.org/display/PLUG/LDAP+Plugin)
export SONAR_AUTH_REALM=${SONAR_AUTH_REALM:=""}
export SONAR_AUTOCREATE_USERS=${SONAR_AUTOCREATE_USERS:="false"}
export SONAR_LDAP_BIND_DN=${SONAR_LDAP_BIND_DN:="cn=Directory Manager"}
export SONAR_LDAP_BIND_PASSWORD=${SONAR_LDAP_BIND_PASSWORD:=""}
export SONAR_LDAP_URL=${SONAR_LDAP_URL:=""}
export SONAR_LDAP_REALM=${SONAR_LDAP_REALM:=""}
# SONAR_LDAP_AUTHENTICATION: When using LDAP, this is the bind method (simple, GSSAPI, kerberos, CRAM-MD5, DIGEST-MD5)
export SONAR_LDAP_AUTHENTICATION=${SONAR_LDAP_AUTHENTICATION:="simple"}

export SONAR_LDAP_USER_BASEDN=${SONAR_LDAP_USER_BASEDN:="cn=accounts"}
export SONAR_LDAP_USER_REAL_NAME_ATTR=${SONAR_LDAP_USER_REAL_NAME_ATTR:="displayname"}
export SONAR_LDAP_USER_EMAIL_ATTR=${SONAR_LDAP_USER_EMAIL_ATTR:="mail"}
#export SONAR_LDAP_USER_REQUEST=${SONAR_LDAP_USER_REQUEST:="uid"}
export SONAR_LDAP_USER_REQUEST=${SONAR_LDAP_USER_REQUEST:="(&(objectClass=inetOrgPerson)(uid={login}))"}
export SONAR_LDAP_GROUP_BASEDN=${SONAR_LDAP_GROUP_BASEDN:="cn=groups,cn=accounts"}
export SONAR_LDAP_GROUP_REQUEST=${SONAR_LDAP_GROUP_REQUEST:="(&(objectClass=groupOfUniqueNames)(uniqueMember={dn}))"}
export SONAR_LDAP_GROUP_ID_ATTR=${SONAR_LDAP_GROUP_ID_ATTR:="cn"}
export SONAR_LDAP_CONTEXTFACTORY=${SONAR_LDAP_CONTEXTFACTORY:="com.sun.jndi.ldap.LdapCtxFactory"}

## Make the script interactive to set the variables
if [ "$INTERACTIVE" = "true" ]; then
	read -rp "OpenShift Cluster Host http(s)://ocp.example.com: ($OCP_HOST): " choice;
	if [ "$choice" != "" ] ; then
		export OCP_HOST="$choice";
	fi

	read -rp "OpenShift Username: ($ADMIN_USERNAME): " choice;
	if [ "$choice" != "" ] ; then
		export ADMIN_USERNAME="$choice";
	fi

	read -rp "OpenShift Password: ($ADMIN_PASSWORD): " choice;
	if [ "$choice" != "" ] ; then
		export ADMIN_PASSWORD="$choice";
	fi

	read -rp "Persist Data Volume?: ($PERSIST_DATA): " choice;
	if [ "$choice" != "" ] ; then
		export PERSIST_DATA="$choice";
	fi
fi