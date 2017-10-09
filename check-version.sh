#!/bin/sh

JENKINS_BIN_DIR=/var/jenkins/bin
UPDATE_AGENT_DIR=/home/pic
UPDATE_AGENT_LOG_DIR=/home/pic

now=$(date +'%d/%m/%Y %H:%M:%S:%3N')

LAST_KNOWN_VERSION=$(cat $UPDATE_AGENT_DIR/version_jenkins.txt)
echo "$now : LAST_KNOWN_VERSION = $LAST_KNOWN_VERSION" | tee --append $UPDATE_AGENT_LOG_DIR/check-version.log
JENKINS_VERSION=$(curl --silent -I http://pic-jenkins:8080/api/json?pretty=true | grep -Fi "X-Jenkins:" | cut -d ' ' -f 2)
echo "$now : JENKINS_VERSION = $JENKINS_VERSION" | tee --append $UPDATE_AGENT_LOG_DIR/check-version.log

if [ "x$LAST_KNOWN_VERSION" = "x" ]; then
	echo "$JENKINS_VERSION" > $UPDATE_AGENT_DIR/version_jenkins.txt
	LAST_KNOWN_VERSION="$LAST_KNOWN_VERSION"
fi

if [ "$LAST_KNOWN_VERSION" != "$JENKINS_VERSION" ]; then
	echo "$now : Restarting agent-jenkins." | tee --append $UPDATE_AGENT_LOG_DIR/check-version.log
	service jenkinsslave restart
fi

echo "$now : Done." | tee --append $UPDATE_AGENT_LOG_DIR/check-version.log


