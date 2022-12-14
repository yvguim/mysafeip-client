import json as j
import requests

class Client():

    def __init__(self, key, secret):
         self.key = key
         self.secret = secret
         self.token = ""

    def do_auth(self, url):
        data = {
            "key": self.key,
            "secret": self.secret,
            "scope": "cli"
        }
        r = requests.post(url=url, data=data)
        response_text = r.text
        d = j.loads(response_text)   
        try: 
            self.token = d['access_token']
        except:
            raise Exception("Incorrect username or password")
        return d
    
    def do_post(self, url, data):
        headers = {
            'Authorization': ('Bearer ' + self.token),
            'Cli': 'cli'
        }
        response = requests.post(url, headers=headers, data=data)
        return response
    
    def do_get(self, url, data):
        headers = {
            'Authorization': ('Bearer ' + self.token),
            'Cli': 'cli'
        }
    
        response = requests.get(url, headers=headers, data=data)
        return response
    
