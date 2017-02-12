#!/bin/bash
#
# @brief   Show version of openldap server
# @version ver.1.0
# @date    Mon Aug 24 16:00:00 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

#
# @brief  Show version of openldap server
# @param  None
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __openldap_version
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __openldap_version() {
	local FUNC=${FUNCNAME[0]} MSG="None" STATUS
	MSG="openldap version"
	__info_debug_message "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
	local SLAPD=${config_ldapmanager_util[SLAPD]}
	__check_tool "${SLAPD}"
	STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
		eval "${SLAPD} -VV"
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
			return $NOT_SUCCESS
		fi
		__info_debug_message_end "Done" "$FUNC" "$LDAPMANAGER_TOOL"
		return $SUCCESS
	fi
	MSG="Force exit!"
	__info_debug_message_end "$MSG" "$FUNC" "$LDAPMANAGER_TOOL"
	return $NOT_SUCCESS
}

