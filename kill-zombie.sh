#RUN AS A JENKINS SHELL SCRIPT

JENKINS_USER="jenkins"
MAX_DAYS=1
DRY_RUN=1

JENKINS_PIDS=$(pgrep -u $JENKINS_USER)
for pid in $JENKINS_PIDS; do
  cmdline=$(ps h -p $pid -o cmd || echo '[pid exited]')
  build_env=$(cat /proc/$pid/environ 2>/dev/null | tr '\0' '\n' | egrep '^BUILD_ID=' || :)
  if [ -z "$build_env" ]; then
    # Some Jenkins processes, like the slave itself, don't have a BUILD_ID
    # set. We shouldn't kill those.
    echo "Process $pid ($cmdline) not associated with any build. Skipping..."
    continue
  fi
  start_since=$(ps -p $pid -o pid,etime,args | awk 'substr($2,1,index($2,"-")-1)>$MAX_DAYS')
  if [ -z "$start_since" ]; then
    echo "Process $pid ($cmdline) is running for less than $MAX_DAYS day(s). Skipping..."
    continue
  fi
  build_id=$(echo $build_env | cut -d= -f2)
  
  echo "Killing zombie process $pid (from build $build_id)"
  ps -fww -p $pid || :
  if [ -z "$DRY_RUN" ]; then
    kill -9 $pid || :
  fi
  echo ----------

done
