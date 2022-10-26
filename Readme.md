# Mysafeip Client
Mysafeip-client allow user to interact with mysafeip server
Those are simple examples which should be better soon.

## Install:
1. Clone this repository
```$ git clone git@github.com:yvguim/mysafeip-client.git
```

2. Run bootstrap.sh script.
It will build a virtualenv with all you need to run the examples.
```./bootstrap.sh
```
3. Copy settings.py.template to settings.py and set username, password and base_url vars.

## Use it!
Activate your virtualenv with
```source venv/bin/activate
```
Then run get-ip.py for example:
```python get-ips.py
```

And that's it ;)