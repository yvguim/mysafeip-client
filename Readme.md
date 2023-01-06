# Mysafeip Client

Mysafeip-client allow user to interact with [mysafeip server](https://github.com/yvguim/mysafeip).
You should install it first: [https://github.com/yvguim/mysafeip-compose]

## Install:
1. Clone this repository 
```
cd /opt
sudo git clone https://github.com/yvguim/mysafeip-client.git
```

2. Run bootstrap.sh script.
It will build a virtualenv with all what you need to run the examples.
```
cd /opt/mysafeip-client/
sudo ./bootstrap.sh
```

3. Copy settings.py.template to settings.py

```
sudo cp  settings.py.template settings.py
```

Edit the file settings.py:

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
It should respond:
```
<Response [200]>
```

## Configure your firewall

mysafeip-firewall.sh is an example to run manually. Try it and adapt firewall rules to your needs.

When you are really confident about your configuration, edit if necessary and copy cron-mysafeip file to /etc/cron.d:

```
sudo cp cron-mysafeip-client /etc/cron.d/
```


And that's it, it's a bit more secure around you now ;)
