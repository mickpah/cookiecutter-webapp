#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
    {{ cookiecutter.app_name }}.manage
    {{ "~" * (cookiecutter.app_name ~ ".manage")|count }}

    :author: {{ cookiecutter.author }}
    :copyright: © {{ cookiecutter.copyright }}
    :license: {{ cookiecutter.license }}, see LICENSE for more details.

    templated from https://github.com/ryanolson/cookiecutter-webapp
"""
import os
import sys
import subprocess

from flask.ext.script import Command, Manager, Option, Shell, Server
from flask.ext.migrate import MigrateCommand
from werkzeug.serving import run_simple

from {{cookiecutter.app_name}} import create_app
from {{cookiecutter.app_name}}.framework.sql import db
from {{cookiecutter.app_name}}.models.users import User


application = create_app()

manager = Manager(application.app)
TEST_CMD = "py.test tests"


class Worker(Command):

    option_list = (
        Option('-c', '--concurrency', dest='concurrency', default='1'),
        Option('-l', '--loglevel', dest='loglevel', default='debug'),
    )

    def run(self, concurrency, loglevel):
        celery.start(argv=['worker.py', 'worker',
                           '--concurrency', concurrency,
                           '--loglevel', loglevel,
                           ])

class WSGI(Server):

    def __call__(self, app, host, port, use_debugger, use_reloader,
                 threaded, processes, passthrough_errors):

        if use_debugger is None:
            use_debugger = app.debug

        if use_debugger is None:
            use_debugger = True

        if use_reloader is None:
            use_reloader = use_debugger

        run_simple(host, port, application,
                   use_debugger=use_debugger,
                   use_reloader=use_reloader,
                   threaded=threaded,
                   processes=processes,
                   passthrough_errors=passthrough_errors,
                   **self.server_options)

def _make_context():
    """Return context dict for a shell session so you can access
    app, db, and the User model by default.
    """
    return {
        'app': application,
        'api': application.mounts['/api'],
        'frontend': application.app,
        'db': db,
        'User': User
    }

@manager.command
def test():
    """Run the tests."""
    import pytest
    exit_code = pytest.main(['tests', '--verbose'])
    return exit_code

manager.add_command('server', WSGI(host='0.0.0.0'))
manager.add_command('worker', Worker())
manager.add_command('shell', Shell(make_context=_make_context))
manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
