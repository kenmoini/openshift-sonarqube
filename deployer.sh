#!/bin/bash

## Default variables to use
export INTERACTIVE=${INTERACTIVE:="true"}
export OCP_HOST=${OCP_HOST:=""}
export OCP_CREATE_PROJECT=${OCP_CREATE_PROJECT:="true"}
export OCP_PROJECT_NAME=${OCP_PROJECT_NAME:="cicd-sonarqube"}
export OCP_USERNAME=${ADMIN_USERNAME:=""}
export OCP_PASSWORD=${ADMIN_PASSWORD:=""}
export PERSIST_DATA=${PERSIST_DATA:="true"}

export POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE=${POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE:="10Gi"}
export POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT=${POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT:="2Gi"}
export POSTGRES_CONTAINER_CPU_LIMIT=${POSTGRES_CONTAINER_CPU_LIMIT:="2"}
export SONARQUBE_MEMORY_LIMIT=${SONARQUBE_MEMORY_LIMIT:="4Gi"}
export SONARQUBE_CPU_LIMIT=${SONARQUBE_CPU_LIMIT:="4"}
export SONARQUBE_PERSISTENT_VOLUME_SIZE=${SONARQUBE_PERSISTENT_VOLUME_SIZE:="10Gi"}
export FORCE_AUTHENTICATION=${FORCE_AUTHENTICATION:="false"}
## SONAR_AUTH_REALM: The type of authentication that SonarQube should be using (None or LDAP) (Ref - https://docs.sonarqube.org/display/PLUG/LDAP+Plugin)
export SONAR_AUTH_REALM=${SONAR_AUTH_REALM:=""}
export SONAR_AUTOCREATE_USERS=${SONAR_AUTOCREATE_USERS:="true"}
export SONAR_LDAP_BIND_DN=${SONAR_LDAP_BIND_DN:="cn=Directory Manager"}
export SONAR_LDAP_BIND_PASSWORD=${SONAR_LDAP_BIND_PASSWORD:=""}
export SONAR_LDAP_URL=${SONAR_LDAP_URL:="ldaps://idm.example.com:636"}
export SONAR_LDAP_REALM=${SONAR_LDAP_REALM:="example.com"}
## SONAR_LDAP_AUTHENTICATION: When using LDAP, this is the bind method (simple, GSSAPI, kerberos, CRAM-MD5, DIGEST-MD5)
export SONAR_LDAP_AUTHENTICATION=${SONAR_LDAP_AUTHENTICATION:="simple"}
export SONAR_LDAP_USER_BASEDN=${SONAR_LDAP_USER_BASEDN:="cn=accounts,dc=example,dc=com"}
export SONAR_LDAP_USER_REAL_NAME_ATTR=${SONAR_LDAP_USER_REAL_NAME_ATTR:="displayname"}
export SONAR_LDAP_USER_EMAIL_ATTR=${SONAR_LDAP_USER_EMAIL_ATTR:="mail"}
## export SONAR_LDAP_USER_REQUEST=${SONAR_LDAP_USER_REQUEST:="uid"}
export SONAR_LDAP_USER_REQUEST=${SONAR_LDAP_USER_REQUEST:="(&(objectClass=inetOrgPerson)(uid={login}))"}
export SONAR_LDAP_GROUP_BASEDN=${SONAR_LDAP_GROUP_BASEDN:="cn=groups,cn=accounts,dc=example,dc=com"}
export SONAR_LDAP_GROUP_REQUEST=${SONAR_LDAP_GROUP_REQUEST:="(&(objectClass=groupOfUniqueNames)(uniqueMember={dn}))"}
export SONAR_LDAP_GROUP_ID_ATTR=${SONAR_LDAP_GROUP_ID_ATTR:="cn"}
export SONAR_LDAP_CONTEXTFACTORY=${SONAR_LDAP_CONTEXTFACTORY:="com.sun.jndi.ldap.LdapCtxFactory"}

## Make the script interactive to set the variables
if [ "$INTERACTIVE" = "true" ]; then
	read -rp "OpenShift Cluster Host http(s)://ocp.example.com: ($OCP_HOST): " choice;
	if [ "$choice" != "" ] ; then
		export OCP_HOST="$choice";
	fi

	read -rp "OpenShift Username: ($OCP_USERNAME): " choice;
	if [ "$choice" != "" ] ; then
		export OCP_USERNAME="$choice";
	fi

	read -rsp "OpenShift Password: ($OCP_PASSWORD): " choice;
	if [ "$choice" != "" ] ; then
		export OCP_PASSWORD="$choice";
	fi
    echo -e ""

	read -rp "Create OpenShift Project? (true/false) ($OCP_CREATE_PROJECT): " choice;
	if [ "$choice" != "" ] ; then
		export OCP_CREATE_PROJECT="$choice";
	fi

	read -rp "OpenShift Project Name ($OCP_PROJECT_NAME): " choice;
	if [ "$choice" != "" ] ; then
		export OCP_PROJECT_NAME="$choice";
	fi

	read -rp "Persist Data Volume?: ($PERSIST_DATA): " choice;
	if [ "$choice" != "" ] ; then
		export PERSIST_DATA="$choice";
	fi
    echo -e ""

    read -rp "PostgreSQL Memory Limit: ($POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT): " choice;
    if [ "$choice" != "" ] ; then
        export POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT="$choice";
    fi

    read -rp "PostgreSQL CPU Limit: ($POSTGRES_CONTAINER_CPU_LIMIT): " choice;
    if [ "$choice" != "" ] ; then
        export POSTGRES_CONTAINER_CPU_LIMIT="$choice";
    fi

    if [ "$PERSIST_DATA" == "true" ] ; then

        read -rp "PostgreSQL PV Size?: ($POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE): " choice;
        if [ "$choice" != "" ] ; then
            export POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE="$choice";
        fi

    fi
    echo -e ""

    read -rp "SonarQube Memory Limit: ($SONARQUBE_MEMORY_LIMIT): " choice;
    if [ "$choice" != "" ] ; then
        export SONARQUBE_MEMORY_LIMIT="$choice";
    fi

    read -rp "SonarQube CPU Limit: ($SONARQUBE_CPU_LIMIT): " choice;
    if [ "$choice" != "" ] ; then
        export SONARQUBE_CPU_LIMIT="$choice";
    fi

    if [ "$PERSIST_DATA" == "true" ] ; then

        read -rp "SonarQube PV Size?: ($SONARQUBE_PERSISTENT_VOLUME_SIZE): " choice;
        if [ "$choice" != "" ] ; then
            export SONARQUBE_PERSISTENT_VOLUME_SIZE="$choice";
        fi

    fi
    echo -e ""

    read -rp "SonarQube Force Authentication: ($FORCE_AUTHENTICATION): " choice;
    if [ "$choice" != "" ] ; then
        export FORCE_AUTHENTICATION="$choice";
    fi

    read -rp "SonarQube Authentication Realm [blank or LDAP]: ($SONAR_AUTH_REALM): " choice;
    if [ "$choice" != "" ] ; then
        export SONAR_AUTH_REALM="$choice";
    fi
    echo -e ""

    shopt -s nocasematch
    if [[ "$SONAR_AUTH_REALM" == "LDAP" ]] ; then
        shopt -u nocasematch

        read -rp "Auto Create Users from LDAP: ($SONAR_AUTOCREATE_USERS): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_AUTOCREATE_USERS="$choice";
        fi

        read -rp "LDAP Bind DN: ($SONAR_LDAP_BIND_DN): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_BIND_DN="$choice";
        fi

        read -rsp "LDAP Bind Password: ($SONAR_LDAP_BIND_PASSWORD): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_BIND_PASSWORD="$choice";
        fi
        echo -e ""

        read -rp "LDAP Host: ($SONAR_LDAP_URL): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_URL="$choice";
        fi

        read -rp "LDAP Default Realm: ($SONAR_LDAP_REALM): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_REALM="$choice";
        fi

        read -rp "LDAP Auth Method [simple, GSSAPI, kerberos, CRAM-MD5, DIGEST-MD5]: ($SONAR_LDAP_AUTHENTICATION): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_AUTHENTICATION="$choice";
        fi

        read -rp "LDAP User Base DN: ($SONAR_LDAP_USER_BASEDN): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_USER_BASEDN="$choice";
        fi

        read -rp "LDAP User Display Name Attribute: ($SONAR_LDAP_USER_REAL_NAME_ATTR): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_USER_REAL_NAME_ATTR="$choice";
        fi

        read -rp "LDAP User Email Attribute: ($SONAR_LDAP_USER_EMAIL_ATTR): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_USER_EMAIL_ATTR="$choice";
        fi

        read -rp "LDAP User Search Request: ($SONAR_LDAP_USER_REQUEST): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_USER_REQUEST="$choice";
        fi

        read -rp "LDAP Group Base DN: ($SONAR_LDAP_GROUP_BASEDN): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_GROUP_BASEDN="$choice";
        fi

        read -rp "LDAP Group Search Request: ($SONAR_LDAP_GROUP_REQUEST): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_GROUP_REQUEST="$choice";
        fi

        read -rp "LDAP Group ID Attribute: ($SONAR_LDAP_GROUP_ID_ATTR): " choice;
        if [ "$choice" != "" ] ; then
            export SONAR_LDAP_GROUP_ID_ATTR="$choice";
        fi
        echo -e ""

    fi
    shopt -u nocasematch

fi

echo "Log in to OpenShift..."
oc login $OCP_HOST -u $OCP_USERNAME -p $OCP_PASSWORD

echo "Create/Set Project..."
if [ "$OCP_CREATE_PROJECT" = "true" ]; then
    oc new-project $OCP_PROJECT_NAME --description="CI/CD Static Code Testing with SonarQube" --display-name="CI/CD - SonarQube"
fi
if [ "$OCP_CREATE_PROJECT" = "false" ]; then
    oc project $OCP_PROJECT_NAME
fi

echo "Deploying template..."
if [ "$PERSIST_DATA" = "true" ]; then
    oc process -f sonarqube-persistent-template.yml \
    -p POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE="$POSTGRES_PERSISTENT_VOLUME_CLAIM_SIZE" \
    -p POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT="$POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT" \
    -p POSTGRES_CONTAINER_CPU_LIMIT="$POSTGRES_CONTAINER_CPU_LIMIT" \
    -p SONARQUBE_MEMORY_LIMIT="$SONARQUBE_MEMORY_LIMIT" \
    -p SONARQUBE_CPU_LIMIT="$SONARQUBE_CPU_LIMIT" \
    -p SONARQUBE_PERSISTENT_VOLUME_SIZE="$SONARQUBE_PERSISTENT_VOLUME_SIZE" \
    -p FORCE_AUTHENTICATION="$FORCE_AUTHENTICATION" \
    -p SONAR_AUTH_REALM="${SONAR_AUTH_REALM^^}" \
    -p SONAR_AUTOCREATE_USERS="$SONAR_AUTOCREATE_USERS" \
    -p SONAR_LDAP_BIND_DN="$SONAR_LDAP_BIND_DN" \
    -p SONAR_LDAP_BIND_PASSWORD="$SONAR_LDAP_BIND_PASSWORD" \
    -p SONAR_LDAP_URL="$SONAR_LDAP_URL" \
    -p SONAR_LDAP_REALM="$SONAR_LDAP_REALM" \
    -p SONAR_LDAP_AUTHENTICATION="$SONAR_LDAP_AUTHENTICATION" \
    -p SONAR_LDAP_USER_BASEDN="$SONAR_LDAP_USER_BASEDN" \
    -p SONAR_LDAP_USER_REAL_NAME_ATTR="$SONAR_LDAP_USER_REAL_NAME_ATTR" \
    -p SONAR_LDAP_USER_EMAIL_ATTR="$SONAR_LDAP_USER_EMAIL_ATTR" \
    -p SONAR_LDAP_USER_REQUEST="$SONAR_LDAP_USER_REQUEST" \
    -p SONAR_LDAP_GROUP_BASEDN="$SONAR_LDAP_GROUP_BASEDN" \
    -p SONAR_LDAP_GROUP_REQUEST="$SONAR_LDAP_GROUP_REQUEST" \
    -p SONAR_LDAP_GROUP_ID_ATTR="$SONAR_LDAP_GROUP_ID_ATTR" \
    -p SONAR_LDAP_CONTEXTFACTORY="$SONAR_LDAP_CONTEXTFACTORY" | oc apply -f-
else
    oc process -f sonarqube-template.yml \
    -p POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT="$POSTGRES_CONTAINER_MEMORY_SIZE_LIMIT" \
    -p POSTGRES_CONTAINER_CPU_LIMIT="$POSTGRES_CONTAINER_CPU_LIMIT" \
    -p SONARQUBE_MEMORY_LIMIT="$SONARQUBE_MEMORY_LIMIT" \
    -p SONARQUBE_CPU_LIMIT="$SONARQUBE_CPU_LIMIT" \
    -p FORCE_AUTHENTICATION="$FORCE_AUTHENTICATION" \
    -p SONAR_AUTH_REALM="$SONAR_AUTH_REALM" \
    -p SONAR_AUTOCREATE_USERS="$SONAR_AUTOCREATE_USERS" \
    -p SONAR_LDAP_BIND_DN="$SONAR_LDAP_BIND_DN" \
    -p SONAR_LDAP_BIND_PASSWORD="$SONAR_LDAP_BIND_PASSWORD" \
    -p SONAR_LDAP_URL="$SONAR_LDAP_URL" \
    -p SONAR_LDAP_REALM="$SONAR_LDAP_REALM" \
    -p SONAR_LDAP_AUTHENTICATION="$SONAR_LDAP_AUTHENTICATION" \
    -p SONAR_LDAP_USER_BASEDN="$SONAR_LDAP_USER_BASEDN" \
    -p SONAR_LDAP_USER_REAL_NAME_ATTR="$SONAR_LDAP_USER_REAL_NAME_ATTR" \
    -p SONAR_LDAP_USER_EMAIL_ATTR="$SONAR_LDAP_USER_EMAIL_ATTR" \
    -p SONAR_LDAP_USER_REQUEST="$SONAR_LDAP_USER_REQUEST" \
    -p SONAR_LDAP_GROUP_BASEDN="$SONAR_LDAP_GROUP_BASEDN" \
    -p SONAR_LDAP_GROUP_REQUEST="$SONAR_LDAP_GROUP_REQUEST" \
    -p SONAR_LDAP_GROUP_ID_ATTR="$SONAR_LDAP_GROUP_ID_ATTR" \
    -p SONAR_LDAP_CONTEXTFACTORY="$SONAR_LDAP_CONTEXTFACTORY" | oc apply -f-
fi
