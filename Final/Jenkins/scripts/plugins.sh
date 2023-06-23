#!/bin/bash
set -e 
PluginList=(
"ant"
"antisamy-markup-formatter"
"build-timeout"
"docker-plugin"
"cloudbees-folder"
"credentials-binding"
"email-ext"
"git"
"github-branch-source"
"gradle"
"ldap"
"mailer"
"matrix-auth"
"pam-auth"
"pipeline-github-lib"
"pipeline-stage-view"
"ssh-slaves"
"timestamper"
"workflow-aggregator"
"ws-cleanup"
)

for plugin in ${PluginList[@]}; do
   java -jar jenkins-cli.jar -auth admin:admin -s http://localhost:8080/ install-plugin "${plugin}"
done

echo "Plugins installed!"