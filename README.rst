Run an upgrade test with OpenStack-Ansible
##########################################

This play will deploy a given branch of OpenStack-Ansible and then upgrade to another given branch. Finally the play will run tempest to ensure that everything is working post upgrade.


How to use this
---------------

* You will need a Rackspace Public Cloud account.
* Fill in the os-creds.yml file with your Public Cloud Credentials.
* Execute the simple test playbook.

Example command

.. code-block:: bash

  ansible-playbook -i inventory -e @os-creds.yml osa-nightly-upgrade-test.yml


Special Options
^^^^^^^^^^^^^^^

osa_instance_name: This is a sting variable and can be used to set the instance name to something special

osa_save_instance: This is a boolean variable. If set the playbook will keep the upgrade instance online once complete.


Example command using the "special" options

.. code-block:: bash

    ansible-playbook -i inventory \
                     -e "osa_save_instance=${SAVE_INSTANCE}" \
                     -e "osa_instance_name=${INSTANCE_NAME}" \
                     -e @os-creds.yml \
                     osa-nightly-upgrade-test.yml


Automated Upgrade testing
-------------------------

1. Clone repo to /opt

2. Place the scrpits in the following locations:
      * scripts/osa-upgrade-testing.cron.sh > /etc/cron.daily/osa-upgrade-testing
      * scripts/run-tagged-tests.sh > /root/run-tagged-tests.sh

3. Place the os-creds.yml file in /root and fill in your details.

4. Test by running the /root/run-tagged-tests.sh script
