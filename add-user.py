from mysafeip_client import Client
import settings as set

cli = Client(set.username,set.password)
cli.do_auth(set.login_url)

json = {
  "is_active": True,
  "email": "another_user@example.com",
  "is_admin": False,
  "password": "another_password"
}

r = cli.do_post(set.post_user_url,json)
print(r.text)