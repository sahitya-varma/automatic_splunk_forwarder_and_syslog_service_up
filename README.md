# automatic_splunk_forwarder_and_syslog_service_up
#author:sahitya varma
#this shell(bash) script will bring the Splunk Heavy forwarder up, if the service is down
#Also Bring the syslog service up, if the service is down
#it will add the scripts to cron tab for automatic triggering

#!/bin/bash

mkdir /opt/scripts
cd /opt/scripts/
> automatic_splunk_up.sh

echo "#This script verifies the Splunk status every 10 minutes; it will bring Splunk Up if Splunk is down.
#This script itself runs the command Splunk start using the "splunk user"
#Script author: Sahitya Varma

#!/bin/bash


#setting echo off
set echo off


#go into the Splunk/bin directory
cd /opt/splunk/bin/

#Verify Splunk status and Take input into the variable "splunk_status"
splunk_status=$(./splunk status | sed -n '1 p' | awk '{print substr($0,12,7);exit}')

#echo $splunk_status

#checking the splunk_status
if [[ "$splunk_status" == *"not"* ]]
then

#echo "executing command cd /opt/splunk/bin"
cd /opt/splunk/bin/

#executing command splunk start as splunk user
sudo -u splunk ./splunk start

echo -
echo -
cd /opt/splunk/bin/
./splunk status
echo "Splunk started, now it is running fine"

#If condition fails, that means Splunk is running already
else
echo "Splunk is running fine,exiting script"
fi
" >> automatic_splunk_up.sh


> automatic_syslog_up.sh
echo "#This script verifies the Syslog status every 10 minutes, bringing Syslog Up if Syslog is down.
#Script author: Sahitya Varma

#!/bin/bash
echo "Script is running"
#Verifying the Syslog status and adding that value into variable syslog_status
syslog_status=$(systemctl status syslog-ng  | sed -n '3 p'| awk '{print substr($0,12,7);exit}')

#echo $syslog_status >> /tmp/splunk_script_output/syslogstatus.log

#Checking if condition for whether Syslog is active or not
if [[ "$syslog_status" == *"active"* ]]; then
echo "syslog is up and running fine"
echo "exiting script"
#Entering else condition
else
echo "syslog-ng is not active currently, bringing it up"
#echo "syslog-ng service is not active" >> /tmp/splunk_script_output/syslogstatus.log
#echo "starting syslog-ng service... " >> /tmp/splunk_script_output/syslogstatus.log

#starting the syslog service
systemctl start syslog-ng
#echo "program still running..." >> /tmp/splunk_script_output/syslogstatus.log
sleep 10s
fi" >> automatic_syslog_up.sh





echo "*/5 * * * * root /opt/scripts/automatic_splunk_up.sh" >> /etc/crontab
echo "*/5 * * * * root /opt/scripts/automatic_syslog_up.sh" >> /etc/crontab
