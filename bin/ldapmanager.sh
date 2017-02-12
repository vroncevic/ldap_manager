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

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_root.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/check_op.sh
.	${UTIL}/bin/logging.sh
.	${UTIL}/bin/load_conf.sh
.	${UTIL}/bin/load_util_conf.sh
.	${UTIL}/bin/progress_bar.sh

LDAPMANAGER_TOOL=ldapmanager
LDAPMANAGER_VERSION=ver.1.0
LDAPMANAGER_HOME=${UTIL_ROOT}/${LDAPMANAGER_TOOL}/${LDAPMANAGER_VERSION}
LDAPMANAGER_CFG=${LDAPMANAGER_HOME}/conf/${LDAPMANAGER_TOOL}.cfg
LDAPMANAGER_UTIL_CFG=${LDAPMANAGER_HOME}/conf/${LDAPMANAGER_TOOL}_util.cfg
LDAPMANAGER_LOG=${LDAPMANAGER_HOME}/log

.	${LDAPMANAGER_HOME}/bin/openldap_operation.sh

declare -A LDAPMANAGER_USAGE=(
	[USAGE_TOOL]="__${LDAPMANAGER_TOOL}"
	[USAGE_ARG1]="[OPERATION] start | stop | restart | status | version"
	[USAGE_EX_PRE]="# Restart openLDAP Server"
	[USAGE_EX]="__${LDAPMANAGER_TOOL} restart"
)

declare -A LDAPMANAGER_LOGGING=(
	[LOG_TOOL]="${LDAPMANAGER_TOOL}"
	[LOG_FLAG]="info"
	[LOG_PATH]="${LDAPMANAGER_LOG}"
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
# @retval Function __ldapmanager exit with integer value
#			0   - tool finished with success operation
#			128 - missing argument(s) from cli
#			129 - failed to load tool script configuration from files
#			131 - wrong argument (operation)
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# OP="start"
# __ldapmanager "$OP"
#
function __ldapmanager() {
	local OP=$1
	if [ -n "${OP}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS_CONF STATUS_CONF_UTIL STATUS
		MSG="Loading basic and util configuration!"
		__info_debug_message "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
		__progress_bar PB_STRUCTURE
		declare -A config_ldapmanager=()
		__load_conf "$LDAPMANAGER_CFG" config_ldapmanager
		STATUS_CONF=$?
		declare -A config_ldapmanager_util=()
		__load_util_conf "$LDAPMANAGER_UTIL_CFG" config_ldapmanager_util
		STATUS_CONF_UTIL=$?
		declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
		__check_status STATUS_STRUCTURE
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
			exit 129
		fi
		TOOL_DBG=${config_ldapmanager[DEBUGGING]}
		TOOL_LOG=${config_ldapmanager[LOGGING]}
		TOOL_NOTIFY=${config_ldapmanager[EMAILING]}
		local OPERATIONS=${config_ldapmanager_util[LDAP_OPERATIONS]}
		IFS=' ' read -ra OPS <<< "${OPERATIONS}"
		__check_op "${OP}" "${OPS[*]}"
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			__openldap_operation "${OP}"
			MSG="Operation: ${OP} openldap server"
			LDAPMANAGER_LOGGING[LOG_MSGE]=$MSG
			LDAPMANAGER_LOGGING[LOG_FLAG]="info"
			__logging LDAPMANAGER_LOGGING
			__info_debug_message_end "Done" "$FUNC" "$LDAPMANAGER_TOOL"
			exit 0
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
		exit 130
	fi
	__usage LDAPMANAGER_USAGE
	exit 128
}

#
# @brief   Main entry point
# @param   Value required operation to be done
# @exitval Script tool ldapmanager exit with integer value
#			0   - tool finished with success operation
#			127 - run tool script as root user from cli
#			128 - missing argument(s) from cli
#			129 - failed to load tool script configuration from files
#			131 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "${LDAPMANAGER_NAME} ${LDAPMANAGER_VERSION}" "`date`"
__check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__ldapmanager $1
fi

exit 127

