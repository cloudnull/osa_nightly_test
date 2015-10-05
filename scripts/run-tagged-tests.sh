#!/usr/bin/env bash

LAST_JUNO_TAGS="$(git ls-remote --tags https://github.com/openstack/openstack-ansible | awk -F'refs/tags/' '{print $2}' | grep -v '\^' | uniq | sort --version-sort | grep 10 | tail -n 5)"
KILO_TAG="$(git ls-remote --tags https://github.com/openstack/openstack-ansible | awk -F'refs/tags/' '{print $2}' | grep -v '\^' | uniq | sort --version-sort| grep 11 | tail -n 1)"

SESSION_NUM=0
SESSION_NAME="${SESSION_NAME:-upgrade-testing-tags}"

tmux new-session -d -s ${SESSION_NAME}
for i in ${LAST_JUNO_TAGS}; do
  if [ "${SESSION_NUM}" != 0 ]; then
    tmux new-window -t ${SESSION_NAME}:${SESSION_NUM} -n test-$i
  fi

  sleep 3
  tmux send-keys -t ${SESSION_NAME}:${SESSION_NUM} "OSA_TARGET=${KILO_TAG} OSA_SOURCE=$i INSTANCE_NAME=UpgradeTest$i-${KILO_TAG} /etc/cron.daily/osa-upgrade-testing" C-m
  SESSION_NUM=$((${SESSION_NUM}+1))
done
