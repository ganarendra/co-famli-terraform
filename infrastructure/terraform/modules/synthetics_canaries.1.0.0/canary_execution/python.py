import urllib.request
import requests
import time

with open('dev-url.txt', 'r') as file:
    for line in file:
        url = line
        timeout = 5
        try:
            response = requests.get(url, timeout=timeout)
            if response.status_code == 200:
                print(f"{url} is up!")
        except requests.exceptions.RequestException as e:
            print(f"{url} is down")