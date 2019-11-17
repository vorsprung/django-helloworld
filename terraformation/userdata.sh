#!/bin/bash
aws s3 cp s3://djangoupdater/latest latest
bash ./latest
