CONNECTIONS ?= 500
RESULTS     ?= results.$(CONNECTIONS).log
URL         ?= http://127.0.0.1:5000/
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
	@echo "Creating virtual environment and downloading requirements"
	python3 -m venv venv && \
	    . venv/bin/activate; \
	    pip install wheel && \
	    pip install -r requirements.txt;

install: venv
	mkdir -p results

ifeq ("$(shell which wrk)", "")
	$(error wrk is not installed)
endif

gunicorn: install
	$(VIRTUALENV); \
	    gunicorn -c config.py -b 0.0.0.0:5000 app:application

meinheld: install
	$(VIRTUALENV); \
	    gunicorn -c config.py -b 0.0.0.0:5000 --worker-class=meinheld.gmeinheld.MeinheldWorker app:application

meinheld_meinheld: install
	$(VIRTUALENV); \
	    python meinheld.wsgi

uwsgi: install
	$(VIRTUALENV); \
	    uwsgi --http :5000 --wsgi-file app.py -p 4 --threads 2 -L -T

cherrypy: install
	$(VIRTUALENV); \
	    python cherrypy.wsgi

test: install
	@echo "preheating..."
	sleep 3
	wrk -t4 -c$(CONNECTIONS) -d30s $(URL) &> /dev/null
	@echo "running benchmark..."
	wrk -t4 -c$(CONNECTIONS) -d3m $(URL) | tee -a results/$(RESULTS)

clean:
	-rm -rf venv
	-rm -f debian-stamp

.PHONY: all install gunicorn meinheld uwsgi cherrypy test clean
