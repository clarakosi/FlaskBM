wrkVersion := $(shell wrk --version 2>/dev/null)
virtualEnv := . venv/bin/activate

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
	echo "" | tee -a results.txt; \
	echo "gunicorn" | tee -a results.txt; \
	gunicorn -w 9 -b 0.0.0.0:5000 app:application

meinheld:
	$(virtualEnv); \
    echo "" | tee -a results.txt; \
    echo "meinheld" | tee -a results.txt; \
	gunicorn -w 9 -b 0.0.0.0:5000 --worker-class=meinheld.gmeinheld.MeinheldWorker app:application

uwsgi:
	$(virtualEnv); \
    echo "" | tee -a results.txt; \
    echo "uwsgi" | tee -a results.txt; \
	uwsgi --http :5000 --wsgi-file app.py --master --processes 9 --enable-threads

cherrypy:
	$(virtualEnv); \
    echo "" | tee -a results.txt; \
    echo "cherrypy" | tee -a results.txt; \
    python cherrypy.py

test:
	@echo "running tests now ..."
	sleep 5
	wrk -t4 -c400 -d30s http://127.0.0.1:5000/ | tee -a results.txt
