#!/bin/bash
aws s3 cp s3://djangoupdater/latest /tmp/latest
chmod 755 /tmp/latest
bash /tmp/latest --noexec
chmod 755 /opt/django/launchersetup.sh
cd /opt/django && bash ./launchersetup.sh
