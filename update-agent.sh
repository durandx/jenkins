#!/bin/sh

JENKINS_BIN_DIR=/var/jenkins/bin
UPDATE_AGENT_LOG_DIR=/home/pic

now=$(date +'%d/%m/%Y %H:%M:%S:%3N')

service jenkinsslave stop
echo "$now : Stopping agent-jenkins." | tee --append $UPDATE_AGENT_LOG_DIR/update-agent.log
sleep 60

now=$(date +'%d/%m/%Y %H:%M:%S:%3N')
echo "$now : Updating agent-jenkins." | tee --append $UPDATE_AGENT_LOG_DIR/update-agent.log
wget http://pic-jenkins:8080/jnlpJars/slave.jar --no-proxy -O $JENKINS_BIN_DIR/slave.jar

sleep 10

now=$(date +'%d/%m/%Y %H:%M:%S:%3N')
echo "$now : Starting agent-jenkins." | tee --append $UPDATE_AGENT_LOG_DIR/update-agent.log
service jenkinsslave start

now=$(date +'%d/%m/%Y %H:%M:%S:%3N') 
echo "$now : Done." | tee --append $UPDATE_AGENT_LOG_DIR/update-agent.log

