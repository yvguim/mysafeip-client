# Mysafeip Client

Mysafeip-client allow user to interact with mysafeip server.
You should [install it first](https://github.com/yvguim/mysafeip-compose)

[Want to know what is MySafeIp?](https://github.com/yvguim/mysafeip)

## Install:
1. Clone this repository 
```
$ git clone https://github.com/yvguim/mysafeip-client.git
```

2. Run bootstrap.sh script.
It will build a virtualenv with all you need to run the examples.
```
./bootstrap.sh
```

3. Copy settings.py.template to settings.py and edit those lines:
```
key = "Token Key generated on MySafeIp server"
secret = "Token secret generated on MySafeIp server"
base_url = "MySafeIp server url"
```

## Use it!
Activate your virtualenv with
```
source venv/bin/activate
```
Then run get-ip.py for example:
```
python3 get-ips.py
```

It will output ip registered and valid on your mysafeip server:
Example (here client is installed on /opt/ path):
```
ubuntu@docker02:~$ cd /opt/mysafeip-client/
ubuntu@docker02:/opt/mysafeip-client$ source venv/bin/activate
(venv) ubuntu@docker02:/opt/mysafeip-client$ python3 get-ips.py 
86.213.73.16
```

To post an ip, you can use the web gui or this command:
```
python3 post-ip.py
```

## Configure your firewall

mysafeip-firewall.sh is an example to run manually. Try it and adapt firewall rules to your needs.

When you are really confident about your configuration, you can add it in crontab (here mysafeip-client has been clone in /opt directory):

```
@reboot root rm /tmp/mysafeip.lock
* * * * * root /usr/bin/flock -n /tmp/mysafeip.lock -c '/opt/mysafeip-client/mysafeip-firewall.sh' >/dev/null 2>&1
```


And that's it, it's a bit more secure around you now ;)
