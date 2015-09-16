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
