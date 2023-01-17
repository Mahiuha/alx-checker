#!/usr/bin/python3
""" Module for printing the id of all tasks of current project. """
from random import randint as rand
from os import environ, path
from sys import argv as av
from requests import get
from json import dump

def get_tasks(project_number):
    """ Prints all of the ids of the tasks in the given project. """

    if path.exists('/tmp/.alxswe_auth_token') is None:
        print("No /tmp/.alxswe_auth_token file...")
        return

    with open('/tmp/.alxswe_auth_token', 'r') as f:
        auth = f.read()

    url = "https://intranet.alxswe.com/projects/{}.json?auth_token={}" \
        .format(project_number, auth)

    response = get(url)

    bad_emoji = ['🤢', '🤕', '🤮', '🥵', '🤒', '😵', '🤯', '🥶', '🩹']

    if response.status_code == 200:
        try:
            tasks = response.json()['tasks']
        except:
            print('{} This project is not available for you yet sorry. {}'
                  .format(bad_emoji[rand(0,8)], bad_emoji[rand(0,8)]))
            return
    else:
        # Error no project found.
        print('{} The project # \033[91m{}\033[m was \033[91m{}\033[m {}'
              .format(bad_emoji[rand(0,8)], project_number,
                      response.json()['error'], bad_emoji[rand(0,8)]))
        return

    number = 0
    tasks_dict = {}
    for task in tasks:
        title = task['title']
        task_id = task['id']
        print('\033[92m{}\033[m - {}'.format(number, title))
        tasks_dict[str(number)] = [title, task_id]
        number += 1

    with open('/tmp/.alxswe_current_project', 'w') as f:
        dump(tasks_dict, f)

    return(tasks_dict)
