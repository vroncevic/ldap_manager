#!/bin/bash
#
# @brief   openLDAP Server Management (wrapper)
# @version ver.1.0
# @date    Mon Aug 24 16:00:00 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/check_op.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/progress_bar.sh

LDAP_MANAGER_TOOL=ldap_manager
LDAP_MANAGER_VERSION=ver.1.0
LDAP_MANAGER_HOME=${UTIL_ROOT}/${LDAP_MANAGER_TOOL}/${LDAP_MANAGER_VERSION}
LDAP_MANAGER_CFG=${LDAP_MANAGER_HOME}/conf/${LDAP_MANAGER_TOOL}.cfg
LDAP_MANAGER_UTIL_CFG=${LDAP_MANAGER_HOME}/conf/${LDAP_MANAGER_TOOL}_util.cfg
LDAP_MANAGER_LOG=${LDAP_MANAGER_HOME}/log

.    ${LDAP_MANAGER_HOME}/bin/openldap_operation.sh

declare -A LDAP_MANAGER_USAGE=(
    [USAGE_TOOL]="${LDAP_MANAGER_TOOL}"
    [USAGE_ARG1]="[OPERATION] start | stop | restart | status | version"
    [USAGE_EX_PRE]="# Restart openLDAP Server"
    [USAGE_EX]="${LDAP_MANAGER_TOOL} restart"
)

declare -A LDAP_MANAGER_LOGGING=(
    [LOG_TOOL]="${LDAP_MANAGER_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${LDAP_MANAGER_LOG}"
    [LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
    [BW]=50
    [MP]=100
    [SLEEP]=0.01
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief  Main function
# @param  Value required operation to be done
# @retval Function __ldap_manager exit with integer value
#            0   - tool finished with success operation
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            131 - wrong argument (operation)
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# OP="start"
# __ldap_manager "$OP"
#
function __ldap_manager {
    local OP=$1
    if [ -n "${OP}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        local STATUS_CONF STATUS_CONF_UTIL STATUS
        MSG="Loading basic and util configuration!"
        info_debug_message "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
        progress_bar PB_STRUCTURE
        declare -A config_ldap_manager=()
        load_conf "$LDAP_MANAGER_CFG" config_ldap_manager
        STATUS_CONF=$?
        declare -A config_ldap_manager_util=()
        load_util_conf "$LDAP_MANAGER_UTIL_CFG" config_ldap_manager_util
        STATUS_CONF_UTIL=$?
        declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
        check_status STATUS_STRUCTURE
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
            exit 129
        fi
        TOOL_DBG=${config_ldap_manager[DEBUGGING]}
        TOOL_LOG=${config_ldap_manager[LOGGING]}
        TOOL_NOTIFY=${config_ldap_manager[EMAILING]}
        local OPERATIONS=${config_ldap_manager_util[LDAP_OPERATIONS]}
        IFS=' ' read -ra OPS <<< "${OPERATIONS}"
        check_op "${OP}" "${OPS[*]}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            __openldap_operation "${OP}"
            MSG="Operation: ${OP} openldap server"
            LDAP_MANAGER_LOGGING[LOG_MSGE]=$MSG
            LDAP_MANAGER_LOGGING[LOG_FLAG]="info"
            logging LDAP_MANAGER_LOGGING
            info_debug_message_end "Done" "$FUNC" "$LDAP_MANAGER_TOOL"
            exit 0
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$LDAP_MANAGER_TOOL"
        exit 130
    fi
    usage LDAP_MANAGER_USAGE
    exit 128
}

#
# @brief   Main entry point
# @param   Value required operation to be done
# @exitval Script tool ldap_manager exit with integer value
#            0   - tool finished with success operation
#            127 - run tool script as root user from cli
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#            131 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "${LDAP_MANAGER_TOOL} ${LDAP_MANAGER_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __ldap_manager $1
fi

exit 127

