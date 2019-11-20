#!/bin/bash
asgname=$(terraform show| perl -ne 'print $1 if m#autoScalingGroupName/([^"]+)#')
aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$asgname" --max-size=6 --min-size=6
sleep 10
aws autoscaling update-auto-scaling-group --auto-scaling-group-name "$asgname" --max-size=3 --min-size=3

