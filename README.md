# WSGI container benchmarking with wrk

## Installing wrk
This repo assumes that you have python3 and [wrk](https://github.com/wg/wrk) installed and properly configured.

wrk installation:
* [Mac Users](https://github.com/wg/wrk/wiki/Installing-wrk-on-OS-X)
* [Linux](https://github.com/wg/wrk/wiki/Installing-wrk-on-Linux)
* [Windows](https://github.com/wg/wrk/wiki/Installing-wrk-on-Windows-10)


## Benchmarking a WSGI implementation

### Start the test application

For example, to start the application using gunicorn with the default worker class:

    $ make gunicorn
    
*Other wsgi server options are: meinheld, uwsgi, and cherrypy*


### Run the benchmark

From another terminal, or (preferably) another machine:

    $ make test URL=http://127.0.0.1:5000/ CONNECTIONS=500 RESULTS=gunicorn.500.log

The results will be in `results/` folder. `CONNECTIONS` and `RESULTS` default to 500 and result.500.log, respectively.


## Run parser
parse.py will parse the results, producing a CSV file. Simply pass in the directory with the results:
    
    $ python parse.py results > results.csv


