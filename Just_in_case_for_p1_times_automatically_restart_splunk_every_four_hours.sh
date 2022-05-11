#!/bin/bash


#setting echo off
set echo off

#stop the splunk from root user
/opt/splunk/bin/splunk stop

#bring ths splunk folder to splunk user
chown -R splunk:splunk  /opt/splunk
chown -R splunk:splunk  /opt/splunk/

#start splunk as the Splunk user
sudo -u splunk /opt/splunk/bin/splunk start

#setting echo off
set echo off