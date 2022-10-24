import json as j
import requests

class Client():

    def __init__(self, username, password):
         self.username = username
         self.password = password
         self.token = ""

    def do_auth(self, url):
        data = {
            "username": self.username,
            "password": self.password
        }
        r = requests.post(url=url, data=data)
        response_text = r.text
        d = j.loads(response_text)   
        self.token = d['access_token']
        return d
    
    def do_post(self, url, json):
        headers = {
            'Authorization': ('Bearer ' + self.token)
        }
        response = requests.post(url, headers=headers, json=json)
        return response
    
    def do_get(self, url, json):
        headers = {
            'Authorization': ('Bearer ' + self.token)
        }
    
        response = requests.get(url, headers=headers, json=json)
        return response
    