#!/bin/bash
#
# @brief   openLDAP manager
# @version ver.3.0
# @date    Tue 30 Nov 2021 08:25:14 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/check_tool.sh

LDAP_MANAGER_TOOL=ldap_manager
LDAP_MANAGER_VERSION=ver.3.0
LDAP_MANAGER_HOME=${UTIL_ROOT}/${LDAP_MANAGER_TOOL}/${LDAP_MANAGER_VERSION}

.    ${LDAP_MANAGER_HOME}/bin/openldap_version.sh

declare -A OPENLDAP_OPERATION_USAGE=(
    [USAGE_TOOL]="__openldap_operation"
    [USAGE_ARG1]="[SYSTEMCTL] System ctl path"
    [USAGE_ARG2]="[SLAPD] Open LDAP SLAPD path"
    [USAGE_ARG3]="[OPERATION] start | stop | restart | status | version"
    [USAGE_EX_PRE]="# Restart openLDAP Server"
    [USAGE_EX]="__openldap_operation restart"
)

#
# @brief  Executing operation with openldap service
# @param  Values required systemctl, slapd paths and option
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __openldap_operation $SCTL $SLAPD $OP
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
# else
#    # false
# fi
#
function __openldap_operation {
    local SCTL=$1 SLAPD=$2 OP=$3
    if [ -z "${SCTL}" || -z "${SLAPD}" || -z "${OP}" ]; then
        usage OPENLDAP_OPERATION_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="Run operation [${OP}]"
    info_debug_message "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
    check_tool "${SCTL}"
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
        return $NOT_SUCCESS
    fi
    if [ "${OP}" == "version" ]; then
        __openldap_version $SLAPD
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
            return $NOT_SUCCESS
        fi
    else
        echo "${SCTL} ${OP} ldap.service"
        eval "${SCTL} ${OP} ldap.service"
        STATUS=$?
        if [ $STATUS -ne $SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
            return $NOT_SUCCESS
        fi
    fi
    info_debug_message_end "Done" "$FUNC" "$LDAP_MANAGER_TOOL"
    return $SUCCESS
}

