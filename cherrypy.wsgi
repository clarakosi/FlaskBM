from cheroot.wsgi import Server as WSGIServer, PathInfoDispatcher
from app import application

d = PathInfoDispatcher({'/': application})
server = WSGIServer(('0.0.0.0', 5000), d)

if __name__ == '__main__':
    try:
        server.start()
    except KeyboardInterrupt:
        server.stop()
