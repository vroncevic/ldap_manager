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
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/progressbar.sh

LDAPMANAGER_TOOL=ldapmanager
LDAPMANAGER_VERSION=ver.1.0
LDAPMANAGER_HOME=$UTIL_ROOT/$LDAPMANAGER_TOOL/$LDAPMANAGER_VERSION
LDAPMANAGER_CFG=$LDAPMANAGER_HOME/conf/$TOOL_NAME.cfg
LDAPMANAGER_UTIL_CFG=$LDAPMANAGER_HOME/conf/${LDAPMANAGER_TOOL}_util.cfg
LDAPMANAGER_LOG=$LDAPMANAGER_HOME/log

declare -A LDAPMANAGER_USAGE=(
	[USAGE_TOOL]="__$LDAPMANAGER_TOOL"
	[USAGE_ARG1]="[OPERATION] start | stop | restart | status | version"
	[USAGE_EX_PRE]="# Restart openLDAP Server"
	[USAGE_EX]="__$LDAPMANAGER_TOOL restart"	
)

declare -A LDAPMANAGER_LOG=(
	[LOG_TOOL]="$LDAPMANAGER_TOOL"
	[LOG_FLAG]="info"
	[LOG_PATH]="$LDAPMANAGER_LOG"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BAR_WIDTH]=50
	[MAX_PERCENT]=100
	[SLEEP]=0.01
)

TOOL_DEBUG="false"

#
# @brief  Check version of openLDAP server
# @param  None
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __ldapversion
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __ldapversion() {
	local FUNC=${FUNCNAME[0]}
	local MSG="None"
	__checktool "$configldapmanagerutil{SLAPD}"
	local STATUS=$?
	if [ $STATUS -eq $SUCCESS ]; then
	    eval "$configldapmanagerutil{SLAPD} -VV"
		return $SUCCESS
	fi
	MSG="Missing external tool $configldapmanagerutil{SLAPD}"
	if [ "${configldapmanager[LOGGING]}" == "true" ]; then
		LDAPMANAGER_LOG[LOG_MSGE]=$MSG
		LDAPMANAGER_LOG[LOG_FLAG]="error"
		__logging LDAPMANAGER_LOG
	fi
	if [ "${configldapmanager[EMAILING]}" == "true" ]; then
		__sendmail "$MSG" "${configldapmanager[ADMIN_EMAIL]}"
	fi
	return $NOT_SUCCESS
}

#
# @brief  Run operation on ldap service
# @param  Value required cms (start | stop | restart | status)
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __ldapoperation $OPERATION
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __ldapoperation() {
    local OPERATION=$1
    if [ -n "$OPERATION" ]; then
		local MSG="None"
		__checktool "$configldapmanagerutil{SYSTEMCTL}"
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$OPERATION" == "version" ]; then
				__ldapversion
				return $SUCCESS
			fi
			eval "$configldapmanagerutil{SYSTEMCTL} $OPERATION ldap.service"
        	return $SUCCESS
		fi
		MSG="Missing external tool $configldapmanagerutil{SYSTEMCTL}"
		if [ "${configldapmanager[LOGGING]}" == "true" ]; then
			LDAPMANAGER_LOG[LOG_MSGE]=$MSG
			LDAPMANAGER_LOG[LOG_FLAG]="error"
			__logging LDAPMANAGER_LOG
		fi
		if [ "${configldapmanager[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configldapmanager[ADMIN_EMAIL]}"
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief  Main function 
# @param  Value required operation to be done
# @retval Function __ldapmanager exit with integer value
#			0   - tool finished with success operation 
#			128 - missing argument(s) from cli 
#			129 - failed to load tool script configuration from file  
#			130 - failed to load tool script utilities configuration from file
#           131 - wrong argument (operation)
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# OPERATION="start"
# __ldapmanager "$OPERATION"
#
function __ldapmanager() {
    local OPERATION=$1
    if [ -n "$OPERATION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="Loading basic and util configuration"
		printf "$SEND" "$LDAPMANAGER_TOOL" "$MSG"
		__progressbar PB_STRUCTURE
		printf "%s\n\n" ""
		declare -A configldapmanager=()
		__loadconf $LDAPMANAGER_CFG configldapmanager
		local STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Failed to load tool script configuration"
			if [ "${configldapmanager[LOGGING]}" == "true" ]; then
				LDAPMANAGER_LOG[LOG_MSGE]=$MSG
				LDAPMANAGER_LOG[LOG_FLAG]="error"
				__logging LDAPMANAGER_LOG
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$LDAPMANAGER_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$LDAPMANAGER_TOOL" "$MSG"
			fi
			exit 129
		fi
		declare -A configldapmanagerutil=()
		__loadutilconf $LDAPMANAGER_UTIL_CFG configldapmanagerutil
		STATUS=$?
		if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
			MSG="Failed to load tool script utilities configuration"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$LDAPMANAGER_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$LDAPMANAGER_TOOL" "$MSG"
			fi
			if [ "${configldapmanager[LOGGING]}" == "true" ]; then
				LDAPMANAGER_LOG[LOG_MSGE]=$MSG
				LDAPMANAGER_LOG[LOG_FLAG]="error"
				__logging LDAPMANAGER_LOG
			fi
			exit 130
		fi
		OPENLDAP_OP_LIST=( start stop restart status version )
        __checkop "$OPERATION" "${OPENLDAP_OP_LIST[*]}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            __ldapoperation "$OPERATION"
            if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$LDAPMANAGER_TOOL" "$FUNC" "Done"
			else
				printf "$SEND" "$LDAPMANAGER_TOOL" "Done"
			fi
			if [ "${configldapmanager[LOGGING]}" == "true" ]; then
				LDAPMANAGER_LOG[LOG_MSGE]="Done"
				LDAPMANAGER_LOG[LOG_FLAG]="info"
				__logging LDAPMANAGER_LOG
			fi
			exit 0
        fi
		MSG="Check operation to be done: $OPERATION"
		if [ "${configldapmanager[LOGGING]}" == "true" ]; then
			LDAPMANAGER_LOG[LOG_MSGE]=$MSG
			LDAPMANAGER_LOG[LOG_FLAG]="error"
			__logging LDAPMANAGER_LOG
		fi
        exit 131
    fi 
    __usage LDAPMANAGER_USAGE
    exit 128
}

#
# @brief   Main entry point
# @param   Value required operation to be done
# @exitval Script tool ldapmanager exit with integer value
#			0   - tool finished with success operation 
# 			127 - run tool script as root user from cli
#			128 - missing argument(s) from cli 
#			129 - failed to load tool script configuration from file  
#			130 - failed to load tool script utilities configuration from file
#           131 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "$LDAPMANAGER_NAME $LDAPMANAGER_VERSION" "`date`"
__checkroot
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__ldapmanager $1
fi

exit 127

