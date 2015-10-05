#!/usr/bin/env bash
set -v 

INSTANCE_NAME="${INSTANCE_NAME:-Daily-Upgrade}"
TARGET_ADDRESSES=""
SAVE_INSTANCE="${SAVE_INSTANCE:-false}"

LOG_FILE="/tmp/${INSTANCE_NAME}.log"

BASE_TARGET="$(git ls-remote --tags https://github.com/openstack/openstack-ansible | awk -F'refs/tags/' '{print $2}' | grep -v '\^' | uniq | sort --version-sort| grep 11 | tail -n 1)"
BASE_SOURCE="$(git ls-remote --tags https://github.com/openstack/openstack-ansible | awk -F'refs/tags/' '{print $2}' | grep -v '\^' | uniq | sort --version-sort| grep 10 | tail -n 1)"

OSA_TARGET="${OSA_TARGET:-$BASE_TARGET}"
OSA_SOURCE="${OSA_SOURCE:-$BASE_SOURCE}"

if [ -f "${LOG_FILE}" ];then
  rm "${LOG_FILE}"
fi

function message_results () {
  echo -e "$(cat ${LOG_FILE})" > ${LOG_FILE}
  mpack -s "$1" ${LOG_FILE} ${TARGET_ADDRESSES}
}

pushd /opt/osa_nightly_test
  ansible-playbook -i inventory \
                   -e @/root/os-creds.yml \
                   -e "osa_save_instance=${SAVE_INSTANCE}" \
                   -e "osa_instance_name=${INSTANCE_NAME}" \
                   -e "osa_branch_target=${OSA_TARGET}" \
                   -e "osa_branch_source=${OSA_SOURCE}" \
                   osa-nightly-upgrade-test.yml -v > ${LOG_FILE}
  if [ "$?" != "0" ];then
    message_results "OSA upgrade test failed on ${INSTANCE_NAME}"
  else
    message_results "OSA upgrade test succeeded on ${INSTANCE_NAME}"
  fi

  if [ "${SAVE_INSTANCE}" != "true" ];then
    ansible-playbook -i inventory \
                     -e @/root/os-creds.yml \
                     -e "osa_instance_name=${INSTANCE_NAME}" \
                     osa-server-destroy.yml
  fi
popd
