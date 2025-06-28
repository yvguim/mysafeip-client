#!/bin/bash
set -euo pipefail  # Arrêt sur erreur

# Delay between each server check
delay=10

# Temporary path for zones
tmppath="/tmp"

# Directory of your mysafeip-client.sh clone directory:
# if readlink is not installed, set full path to mysafeip-client directory
mysafeipdir=$(dirname "$(readlink -f "$0")")/
command -v ipset >/dev/null || { logger LOG_MYSAFEIP_CLIENT : ipset not found; exit 1; }
[[ -d "$mysafeipdir" ]] || { logger LOG_MYSAFEIP_CLIENT : Directory $mysafeipdir not found; exit 1; }

logger LOG_MYSAFEIP_CLIENT : Script say client is available in ${mysafeipdir} directory

# Fonctions

is_valid_ip() {
    local ip=$1
    [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
}


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
    cp mysafeip.zone mysafeip.zone.previous
    python3 ${mysafeipdir}get-ips.py > mysafeip.zone
    if ! cmp mysafeip.zone mysafeip.zone.previous >/dev/null 2>&1
    then
        logger LOG_MYSAFEIP_CLIENT : Zone change
        logger LOG_MYSAFEIP_CLIENT : Flush mysafeip and mysafeipnet ipset
        ipset flush mysafeip
        ipset flush mysafeipnet
        
        for net in '10.0.0.0/8' '172.16.0.0/12' '192.0.2.0/24' '192.168.0.0/16' '239.192.0.0/14';
        do 
          ipset -A -exist mysafeipnet $net
          logger LOG_MYSAFEIP_CLIENT : Add $net in ipset mysafeipnet
        done

        for ip in $(cat mysafeip.zone);
          do
           if is_valid_ip "$ip"; then
                    ipset -A -exist mysafeip "$ip" && logger LOG_MYSAFEIP_CLIENT : Add $ip in ipset mysafeip
                else
                    logger LOG_MYSAFEIP_CLIENT : ERROR - Invalid IP address: $ip
                fi
          done
    fi
done
