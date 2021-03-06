#!/bin/bash
#
# Usage:
# Ensure the environment variables below are defined, then run the script:
#
# ./make-aws-yml.sh > aws.yml
#
# Copy the resulting file to your Discourse host and use it to bootstrap Discourse:
# $ scp aws.yml ubuntu@$(terraform output DISCOURSE_HOSTNAME):/var/discourse/containers/aws.yml
#
# Then SSH to the server; from /var/discourse run `./launcher bootstrap aws` as root 

echo "
# This file was generated by make-aws-yml.sh
"

echo 'templates:
  - "templates/web.template.yml"
  - "templates/web.ratelimited.template.yml"

expose:
  - "80:80"
  - "2222:22"
  - "5432:5432"
'

envvars="
    LANG
    DISCOURSE_DB_USERNAME
    DISCOURSE_DB_PASSWORD
    DISCOURSE_DB_NAME
    DISCOURSE_DB_HOST
    DISCOURSE_REDIS_HOST
    DISCOURSE_DEVELOPER_EMAILS
    DISCOURSE_HOSTNAME
    DISCOURSE_SMTP_ADDRESS
    DISCOURSE_SMTP_PORT
    DISCOURSE_SMTP_USER_NAME
    DISCOURSE_SMTP_PASSWORD
"

echo "env:"
for ev in $envvars; do
    echo "  ${ev}: '${!ev}'"
done

echo
echo '
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/discourse/docker_manager.git
'
