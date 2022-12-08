from mysafeip_client import Client
import settings as set

cli = Client(set.username,set.password)
cli.do_auth(set.login_url)

data = {
        'ip' : '',
        'action' : 'create',
        'description' : 'created from python cli'
    }

r = cli.do_post(set.post_ip_url, data)
print(r)
