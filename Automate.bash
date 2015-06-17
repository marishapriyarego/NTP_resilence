#!/bin/bash

ntpdate="ntpdate  $1"

echo "AUTOMATION SCRIPT FOR NTPD RELATED TEST" 
echo "Version 0.1" 
echo "Basic Server Related Details"

echo -e `lsb_release -ic` 
echo " Ntp version installed "
echo -e  `ntpd --version`
 T1=`ntpq -p`
 T2="No association ID's returned"
            if [ "$T1" = "$T2" ]; then
                echo Issue in ntp client server configuration
            else
                echo -e "ntp servers already configured \n$T1"
            fi
 


echo -e "\nTest case : TC001 \n Test Case description :To synchronize with the ntp server which do not exists\n commad : ntpdate -u 9.2.2.3"
`ntpdate -u 2.2.2.1`
if [ $? -eq 1 ]; then
    echo Result as expected
else
    echo The server seems to be reachable and already configured as ntp server , please change the server ip to one which doesnt exist
fi

		

echo -e "\nTest case : TC002 \n Test Case description :Trying to get the ntp status , when  ntpd daemon services are not started\n commad : ntpdstat"
echo -e `service ntpd stop`
`ntpstat`
if [ $? -eq 2 ]; then
    echo Result as expected
fi
echo -e `service ntpd start`



echo -e "\nTest case : TC003  \n Test Case description :To synchronize the ntp server and ntp client when ntp client time is equal to ntp server \n commad : ntpdate -u $1"
`$ntpdate`
if [ $? -eq 0 ]; then
    echo Result as expected
else
    echo Error in command excution
fi

echo -e "\nTest case : TC004  \n Add the minpool and maxpool values \n commad : ntpq -p"
echo -e "\n ntpq -p before setting the minpool maxpool value\n"
echo -e `ntpq --p`
echo " server $1 minpoll 4 maxpoll 7" >> /etc/ntp.conf
echo -e "\n After changing the polls\n"
echo `service network restart`
echo -e `ntpq --p`



echo -e "\nTest case :TC005 \n Test Case description : To synchronize the ntp server and ntp client when when the  ntp client time  and ntp server time difference is n is more  \n command : ntpdate -d $1"
echo -e `date -s 'next day'`
echo -e "Trying to synchronize the ntp client and server after teh time is increased"
echo -e `ntpdate -d -d $1`
