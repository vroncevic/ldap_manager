#!/bin/bash
#
# @brief   openLDAP manager
# @version ver.2.0
# @date    Tue 30 Nov 2021 08:25:14 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

#
# @brief  Show version of openldap server
# @param  None
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __openldap_version
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
# else
#    # false
# fi
#
function __openldap_version {
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS
    MSG="openldap version"
    info_debug_message "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
    local SLAPD=${config_ldap_manager_util[SLAPD]}
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

