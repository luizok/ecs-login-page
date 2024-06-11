from time import sleep
import threading

from numpy.random import uniform

import requests


def make_request(*urls):
    while True:
        # sleep(5 * uniform())
        for url in urls:
            res = requests.get(url)
            print(res, uniform())


if __name__ == '__main__':

    # create mutiple threads to make requests
    threads = []
    for _ in range(6):
        thread = threading.Thread(
            target=make_request,
            args=(
                'http://15.228.60.224:3000',
                'http://15.228.60.224:3000/login',
                'http://15.228.60.224:3000/me',
            )
        )
        thread.start()
