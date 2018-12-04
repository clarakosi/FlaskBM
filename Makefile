RESULTS     ?= results.500.log
CONNECTIONS ?= 500
URL         ?= http://127.0.0.1:5000/
PYTHON      ?= /usr/bin/python3
VIRTUALENV  := . venv/bin/activate


all: install

# For WINDOWS USERS:
#venv:
#	@echo "Creating virtual environment and downloading requirements"
#	py -3 -m venv venv && \
#	    venv\Scripts\activate; \
#	    pip install wheel && \
#	    pip install -r requirements.txt;

debian: debian-stamp
debian-stamp:
	sudo apt install -y \
	    gunicorn \
	    uwsgi \
	    wrk \
	    python3
	touch debian-stamp

venv:
	mkdir -p results
	@echo "Creating virtual environment and downloading requirements"
	$(PYTHON) -m venv venv && \
	    . venv/bin/activate; \
	    pip install wheel && \
	    pip install -r requirements.txt;

install: venv

ifeq ("$(shell which wrk)", "")
	$(error wrk is not installed)
endif

gunicorn: venv
	$(VIRTUALENV); \
	    gunicorn -c config.py -b 0.0.0.0:5000 app:application

meinheld: venv
	$(VIRTUALENV); \
	    gunicorn -c config.py -b 0.0.0.0:5000 --worker-class=meinheld.gmeinheld.MeinheldWorker app:application

uwsgi: venv
	$(VIRTUALENV); \
	    uwsgi --http :5000 --wsgi-file app.py -p 4 --threads 2 -L -T

cherrypy: venv
	$(VIRTUALENV); \
	    python cherrypy.wsgi

test: venv
	@echo "running tests now ..."
	sleep 3
	wrk -t4 -c$(CONNECTIONS) -d30s $(URL) | tee -a results/$(RESULTS)

clean:
	-rm -r venv
	-rm debian-stamp

.PHONY: all install gunicorn meinheld uwsgi cherrypy test clean
