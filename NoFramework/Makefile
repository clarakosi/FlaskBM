wrkVersion := $(shell wrk --version 2>/dev/null)
virtualEnv := . venv/bin/activate
result ?= result.txt
connection ?= 500

#virtualEnv := venv\Scripts\activate For WINDOWS

.PHONY: all

all: install

# For WINDOWS USERS:
#install:
#	@echo "Creating virtual environment and downloading requirements"
#	py -3 -m venv venv
#	.venv\Scripts\activate; \
#	pip install -r requirements.txt; 
#ifdef wrkVersion
#	@echo "wrk is properly installed"
#else
#	$(error wrk is not installed)
#endif

install:
	@echo "Creating virtual environment and downloading requirements"
	python3 -m venv venv
	. venv/bin/activate; \
	pip install -r requirements.txt; 
ifdef wrkVersion
	@echo "wrk is properly installed"
else
	$(error wrk is not installed)
endif

gunicorn:
	$(virtualEnv); \
	gunicorn -w 9 -b 0.0.0.0:5000 app:application

meinheld:
	$(virtualEnv); \
	gunicorn -w 9 -b 0.0.0.0:5000 --worker-class=meinheld.gmeinheld.MeinheldWorker app:application

uwsgi:
	$(virtualEnv); \
	uwsgi --http :5000 --wsgi-file app.py --master --processes 9 --enable-threads

cherrypy:
	$(virtualEnv); \
    python cherrypy.wsgi

test:
	@echo "running tests now ..."
	sleep 5
	wrk -t4 -c$(connection) -d30s http://127.0.0.1:5000/ | tee -a results/$(result)
