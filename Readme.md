# Mysafeip Client
Mysafeip-client allow user to interact with mysafeip server
Those are simple examples which should be better soon.

## Install:
1. Clone this repository
<code>
$ git clone https://github.com/yvguim/mysafeip-client.git
</code>

2. Run bootstrap.sh script.
It will build a virtualenv with all you need to run the examples.
<code>
./bootstrap.sh
</code>

3. Copy settings.py.template to settings.py and set username, password and base_url vars.

## Use it!
Activate your virtualenv with
<code>
source venv/bin/activate
</code>
Then run get-ip.py for example:
<code>
python3 get-ips.py
</code>

It will output ip registered and valid on your mysafeip server

To post an ip, you can use the web gui or this command:
<code>
python3 post-ip.py
</code>

## Configure your firewall

`mysafeip-firewall.sh` is an example to run manually. Try it and adapt firewall rules to your needs.

When you are really confident about your config, you can add it in crontab:

<code>
@reboot root rm /tmp/mysafeip.lock
* * * * * root /usr/bin/flock -E 0 -n /tmp/mysafeip.lock /some_path/mysafeip-client/mysafeip-firewall.sh >/dev/null 2>&1
</code>


And that's it, it's a bit more secure around you now ;)
