# Flask Benchmarking with wrk

### Installing wrk
This repo assumes that you have python3 and [wrk](https://github.com/wg/wrk) installed and properly configured.

wrk installation:
* [Mac Users](https://github.com/wg/wrk/wiki/Installing-wrk-on-OS-X)
* [Linux](https://github.com/wg/wrk/wiki/Installing-wrk-on-Linux)
* [Windows](https://github.com/wg/wrk/wiki/Installing-wrk-on-Windows-10)

### Installing dependencies
Run:

    $ make
### Starting Server
To start the gunicorn server in the NoFramework folder simply run:
    
    $ cd NoFramework
    $ make gunicorn

*Other wsgi server options are: meinheld, uwsgi, and cherrypy*

### Running Tests
Once the server of choice is up and running simply run:
    
    $ make test

It will run the test 3 times for 30 seconds each. The results will be in the terminal and results.txt

