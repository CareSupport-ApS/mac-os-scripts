#!/bin/sh

echo "Restarting calendar service";

#/dev/console | /usr/bin/awk '{ print $3 }')
#echo 'Current user:' $loggedInUser;

/usr/bin/su -l $(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }') -c "launchctl stop com.apple.CalendarAgent && launchctl start com.apple.CalendarAgent";


echo "Calendar service restarted";