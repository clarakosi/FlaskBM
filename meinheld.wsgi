# -*- mode: python; -*-


from app import application
import meinheld
from multiprocessing import Process
import signal


workers = []


def run(app, i):
   meinheld.run(app)

def kill_all(sig, st):
   for w in workers:
      w.terminate()

def start(num=4):
   for i in range(num):
      p = Process(name="worker-%d" % i, target=run, args=(application,i))
      workers.append(p)
      p.start()


if __name__ == "__main__":
   signal.signal(signal.SIGTERM, kill_all)
   meinheld.set_keepalive(10)
   meinheld.set_access_logger(None)
   meinheld.set_error_logger(None)
   meinheld.listen(("0.0.0.0", 5000))
   try:
      start()
   except KeyboardInterrupt:
      for w in workers:
         w.terminate()
