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

declare -A OPENLDAP_VERSION_USAGE=(
    [USAGE_TOOL]="__openldap_version"
    [USAGE_ARG1]="[SLAPD] Open LDAP SLAPD path"
    [USAGE_EX_PRE]="# Check version of openLDAP Server"
    [USAGE_EX]="__openldap_version \${SLAPD}"
)

#
# @brief  Show version of openldap server
# @param  Value required slapd path
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __openldap_version $SLAPD
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
# else
#    # false
# fi
#
function __openldap_version {
    local SLAPD=$1
    if [ -z "${SLAPD}" ]; then
        usage OPENLDAP_VERSION_USAGE
        return $NOT_SUCCESS
    fi
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="openldap version"
    info_debug_message "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
    check_tool "${SLAPD}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        eval "${SLAPD} -VV"
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
            return $NOT_SUCCESS
        fi
        info_debug_message_end "Done" "$FUNC" "$LDAP_MANAGER_TOOL"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
    return $NOT_SUCCESS
}

