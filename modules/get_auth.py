#!/usr/bin/python3
""" Module for storing the get_auth method. """
from requests import post
from os import path


def get_auth(email=None, api=None, password=None):
    """ Gets the authentication token for the current user. """

    if email is None or api is None or password is None:
        print('No email, api_key or password given.')
        return False

    if path.exists('/tmp/.alxswe_auth_token'):
        return

    url = "https://intranet.alxswe.com/users/auth_token.json"

    payload = {'api_key': api, 'email': email,
               'password': password, 'scope': 'checker'}

    response = post(url, data=payload)

    status = response.status_code

    result = response.json()

    if status == 200:
        auth = result['auth_token']

        with open('/tmp/.alxswe_auth_token', 'w') as f:
            f.write(auth)

    response_dict = {}
    response_dict[str(status)] = result
    return(response_dict)
