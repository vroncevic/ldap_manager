#!/bin/bash
#
# @brief   Executing operation with openldap service
# @version ver.1.0
# @date    Mon Aug 24 16:00:00 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

.	${LDAPMANAGER_HOME}/bin/openldap_version.sh

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
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __openldap_operation $OP
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __openldap_operation() {
	local OP=$1
	if [ -n "${OP}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		MSG="Run operation [${OP}]"
		__info_debug_message "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
		local SCTL=${config_ldapmanager_util[SYSTEMCTL]}
		__check_tool "${SCTL}"
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "${OP}" == "version" ]; then
				__openldap_version
				STATUS=$?
				if [ $STATUS -eq $NOT_SUCCESS ]; then
					MSG="Force exit!"
					__info_debug_message_end "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
					return $NOT_SUCCESS
				fi
			else
				echo "${SCTL} ${OP} ldap.service"
				eval "${SCTL} ${OP} ldap.service"
				STATUS=$?
				if [ $STATUS -ne $SUCCESS ]; then
					MSG="Force exit!"
					__info_debug_message_end "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
					return $NOT_SUCCESS
				fi
			fi
			__info_debug_message_end "Done" "$FUNC" "$LDAPMANAGER_TOOL"
			return $SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
		return $NOT_SUCCESS
	fi
	__usage OPENLDAP_OPERATION_USAGE
	return $NOT_SUCCESS
}

