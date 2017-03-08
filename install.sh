#!/bin/sh

oc get dc jenkins > /dev/null 2>&1
if test $? -eq 0
then
  echo "Using existing jenkins-ephemeral instance."
else
  oc new-app jenkins-ephemeral -p MEMORY_LIMIT=2048Mi -o yaml | oc apply -f -
fi
oc policy add-role-to-user edit -z jenkins

oc secrets new-sshauth github-secret --ssh-privatekey=$HOME/.ssh/id_jenkins -o yaml | oc apply -f -
oc secrets link builder github-secret

oc apply -f openshift-template.yml