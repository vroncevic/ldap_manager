#!/bin/bash
#
# @brief   openLDAP manager
# @version ver.2.0
# @date    Tue 30 Nov 2021 08:25:14 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

.    ${LDAP_MANAGER_HOME}/bin/openldap_version.sh

declare -A OPENLDAP_OPERATION_USAGE=(
    [USAGE_TOOL]="__openldap_operation"
    [USAGE_ARG1]="[OPERATION] start | stop | restart | status | version"
    [USAGE_EX_PRE]="# Restart openLDAP Server"
    [USAGE_EX]="__openldap_operation restart"
)

#
# @brief  Executing operation with openldap service
# @param  Value required option (start | stop | restart | status | version)
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __openldap_operation $OP
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
# else
#    # false
# fi
#
function __openldap_operation {
    local OP=$1
    if [ -n "${OP}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Run operation [${OP}]"
        info_debug_message "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
        local SCTL=${config_ldap_manager_util[SYSTEMCTL]}
        check_tool "${SCTL}"
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
            return $NOT_SUCCESS
        fi
        if [ "${OP}" == "version" ]; then
            __openldap_version
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
    fi
    usage OPENLDAP_OPERATION_USAGE
    return $NOT_SUCCESS
}

