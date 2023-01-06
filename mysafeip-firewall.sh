#!/bin/bash

# Delay between each server check
delay=10

# Temporary path for zones
tmppath="/tmp"

# Directory of your mysafeip-client.sh clone directory:
# if readlink is not installed, set full path to mysafeip-client directory
mysafeipdir=$(dirname "$(readlink -f "$0")")/
logger LOG_MYSAFEIP_CLIENT : Script say client is available in ${mysafeipdir} directory


# cleanup
logger LOG_MYSAFEIP_CLIENT : Clean old zones in ${tmppath}
cd ${tmppath}
rm -f mysafeip.zone mysafeip.zone.previous
touch mysafeip.zone

# Create mysafeip ipset if not exists:
logger LOG_MYSAFEIP_CLIENT : Create mysafeip and mysafeipnet ipset
ipset create -exist mysafeip hash:ip
ipset create -exist mysafeipnet hash:net

# Activate virtualenv
. ${mysafeipdir}venv/bin/activate
logger LOG_MYSAFEIP_CLIENT : Activate venv

## Configure your firewall rules. 
# Be sure of your config with those two lines before addind a cron job!
#iptables -I INPUT -m set ! --match-set mysafeip src -m set ! --match-set mysafeipnet src -p tcp --dport 22 -j DROP
#iptables -I INPUT -m set ! --match-set mysafeip src -m set ! --match-set mysafeipnet src -p tcp --dport 22 -j LOG 

##Here for docker applications for example:
#iptables -F DOCKER-USER
#iptables -I DOCKER-USER -m set ! --match-set mysafeip src -m set ! --match-set mysafeipnet src -j DROP
#iptables -I DOCKER-USER -m set ! --match-set mysafeip src -m set ! --match-set mysafeipnet src -j LOG
#iptables -I DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# And now let's run the magic ;)
logger LOG_MYSAFEIP_CLIENT : Entering loop
while sleep $delay
do
    mv mysafeip.zone mysafeip.zone.previous
    python3 ${mysafeipdir}get-ips.py | tee mysafeip.zone
    if ! cmp mysafeip.zone mysafeip.zone.previous >/dev/null 2>&1
    then
        logger LOG_MYSAFEIP_CLIENT : Zone change
        logger LOG_MYSAFEIP_CLIENT : Flush mysafeip and mysafeipnet ipset
        ipset flush mysafeip
        ipset flush mysafeipnet
        
        for i in '10.0.0.0/8' '172.16.0.0/12' '192.0.2.0/24' '192.168.0.0/16' '239.192.0.0/14';
        do ipset -A -exist mysafeipnet $i && logger LOG_MYSAFEIP_CLIENT : Add $i in ipset mysafeipnet; done

        for i in $(cat mysafeip.zone);
          do
             if [[ "$i" == 66.66.66.66 ]]
             then
               ipset -A -exist  mysafeipnet 0.0.0.0/1
               ipset -A -exist  mysafeipnet 128.0.0.0/1
               logger LOG_MYSAFEIP_CLIENT : Allow all networks
             else
               ipset -A -exist mysafeip $i && logger LOG_MYSAFEIP_CLIENT : Add $i in ipset mysafeip
             fi
          done
    fi
done
