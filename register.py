from mysafeip_client import Client
import settings as set

cli = Client(set.username,set.password)
cli.do_auth(set.login_url)

data = {
  "email": "your_email@example.com",
  "password": "your_password",
  "confirm_password": "your_password",
        }

r = cli.do_post(set.post_user_url,data)
print(r.text)
