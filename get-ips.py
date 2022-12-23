from mysafeip_client import Client
import settings as set
import json as j

cli = Client(set.key,set.secret)
cli.do_auth(set.login_url)
json = ''
r = cli.do_get(set.get_ips_url,json)
jsonObject = j.loads(r.text)
for ip in jsonObject:
    print(ip['value'])
