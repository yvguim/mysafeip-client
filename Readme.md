# Mysafeip Client
Mysafeip-client allow user to interact with mysafeip server
Those are simple examples which should be better soon.

## Install:
1. Clone this repository
`$ git clone https://github.com/yvguim/mysafeip-client.git
`

2. Run bootstrap.sh script.
It will build a virtualenv with all you need to run the examples.
`./bootstrap.sh
`
3. Copy settings.py.template to settings.py and set username, password and base_url vars.

## Use it!
Activate your virtualenv with
`source venv/bin/activate
`
Then run get-ip.py for example:
`python get-ips.py
`

It will output ip registered and valid on your mysafeip server

## Configure your firewall

`mysafeip-firewall.sh` is an example to run manually then on crontab (with flock for example)

And that's it, it's a bit more secure around you know ;)