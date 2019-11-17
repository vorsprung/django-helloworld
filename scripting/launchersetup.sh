#!/bin/bash
# this is the launch configuration that is run from the self archived copy of the code
# whenever a new instance is started - this is in the "latest" that is downloaded by
# s3 cp in the userdata script
chown -R ubuntu /opt/django
su ubuntu -c 'cd /opt/django;python3 manage.py migrate'
su ubuntu -c 'cd /opt/django;python3 manage.py createsuperuser --no-input --username admin --email admin@mail.com'
su ubuntu -c 'cd /opt/django;python3 manage.py runserver 0.0.0.0:8080 &'
