#!/usr/bin/python3
""" Module for printing the id of all tasks of current project. """
from requests import post
from os import path


def request_correction(task):
    """ Prints all of the ids of the tasks in the given project. """

    if path.exists('/tmp/.alxswe_auth_token') is None:
        print("No /tmp/.alxswe_auth_token file...")
        return

    with open('/tmp/.alxswe_auth_token', 'r') as f:
        auth = f.read()

    url = ("https://intranet.alxswe.com/tasks/{}/"
           "start_correction.json?auth_token={}"
           .format(task, auth))

    response = post(url, data='')

    request_result = response.json()

    return request_result['id']
