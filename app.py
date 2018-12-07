import cherrypy


class Root(object):
        @cherrypy.expose
        def index(self):
            return "Hello World"

cherrypy.config.update({'engine.autoreload.on': False})
cherrypy.config.update({'environment': 'embedded'})
cherrypy.server.unsubscribe()
cherrypy.engine.start()

application = cherrypy.tree.mount(Root())
