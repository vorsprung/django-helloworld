#!/bin/bash
# this is the launch configuration that is run as userdata
# whenever a new instance is started
cd /opt/django
python3 manage.py migrate
python3 manage.py createsuperuser --no-input --username admin --email admin@mail.com
python manage.py runserver &
