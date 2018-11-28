import json

MSG = json.dumps({'value': 'Hello, world!'}).encode('utf-8')


def application(env, start_response):
    path = env['PATH_INFO']
    if path == '/':
        start_response('200 OK', [('Content-Type', 'application/json')])
        return [MSG]

    start_response('404 Not Found', [('Content-Type', 'text/plain')])
    return [b'Not Found']
