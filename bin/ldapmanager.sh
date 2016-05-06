#!/bin/bash
#
# @brief   openLDAP Server Management
# @version ver.1.0
# @date    Mon Aug 24 16:00:00 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#  
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkcfg.sh
. $UTIL/bin/checkop.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

TOOL_NAME=ldapmanager
TOOL_VERSION=ver.1.0
TOOL_HOME=$UTIL_ROOT/$TOOL_NAME/$TOOL_VERSION
TOOL_CFG=$TOOL_HOME/conf/$TOOL_NAME.cfg
TOOL_LOG=$TOOL_HOME/log

declare -A LDAPMANAGER_USAGE=(
	[TOOL_NAME]="__$TOOL_NAME"
	[ARG1]="[OPERATION] start | stop | restart | status | version"
	[EX-PRE]="# Restart openLDAP Server"
	[EX]="__$TOOL_NAME restart"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="info"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

TOOL_DEBUG="false"

SYSTEMCTL="/usr/bin/systemctl"
SLAPD="/usr/lib/openldap/slapd"
OPENLDAP_OP_LIST=( start stop restart status version )

#
# @brief  Check version of openLDAP server
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __ldapversion
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __ldapversion() {
	__checktool "$SLAPD"
	STATUS=$?
	if [ "$STATUS" -eq "$SUCCESS" ]; then
	    eval "$SLAPD -VV"
		return $SUCCESS
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
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#	# true
# else
#	# false
# fi
#
function __ldapoperation() {
    OPERATION=$1
    if [ -n "$OPERATION" ]; then
		__checktool "$SYSTEMCTL"
		STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$OPERATION" == "version" ]; then
				__ldapversion
				return $SUCCESS
			fi
			eval "$SYSTEMCTL $OPERATION ldap.service"
        	return $SUCCESS
		fi
		return $NOT_SUCCESS
    fi 
    return $NOT_SUCCESS
}

#
# @brief Main function 
# @param Value required operation to be done
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# OPERATION="start"
# __ldapmanager "$OPERATION"
#
function __ldapmanager() {
    OPERATION=$1
    if [ -n "$OPERATION" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[LDAP Server manager]"
		fi
        __checkop "$OPERATION" "${OPENLDAP_OP_LIST[*]}"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            __ldapoperation "$OPERATION"
            LOG[MSG]="$OPERATION openLDAP Server"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "[Info] ${LOG[MSG]}"
			fi
            __logging $LOG
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "[Done]"
			fi
			exit 0
        fi
        exit 129
    fi 
    __usage $LDAPMANAGER_USAGE
    exit 128
}

#
# @brief Main entry point
# @param required value operation to be done
# @exitval Script tool atmanger exit with integer value
#			0   - success operation 
# 			127 - run as root user
#			128 - missing argument
#			129 - wrong argument (operation)
#
printf "\n%s\n%s\n\n" "$TOOL_NAME $TOOL_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
	__ldapmanager "$1"
fi

exit 127

