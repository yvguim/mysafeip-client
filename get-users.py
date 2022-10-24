from mysafeip_client import Client
import settings as set
import json as j

cli = Client(set.username,set.password)
cli.do_auth(set.login_url)
json = ''
r = cli.do_get(set.get_users_url,json)

jsonObject = j.loads(r.text)

for user in jsonObject:
    print(user['email'])