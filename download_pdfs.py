import os
import time
import pickle
import shutil
import random
import multiprocessing
from  urllib.request import urlopen

from utils import Config

timeout_secs = 10 # after this many seconds we give up on a paper
if not os.path.exists(Config.pdf_dir): os.makedirs(Config.pdf_dir)
have = set(os.listdir(Config.pdf_dir)) # get list of all pdfs we already have

numok = 0 #multiprocessing.Value('d', 0)
numtot = 0 # multiprocessing.Value('d', 0)
db = pickle.load(open(Config.db_path, 'rb'))

def download_pdf(pdf_url, fname):
  print('fetching %s into %s' % (pdf_url, fname))
  req = urlopen(pdf_url, None, timeout_secs)
  with open(fname, 'wb') as fp:
      shutil.copyfileobj(req, fp)

def process(arg):
  global db, numok, numtot
  pid, j = arg
  pdfs = [x['href'] for x in j['links'] if x['type'] == 'application/pdf']
  assert len(pdfs) == 1
  pdf_url = pdfs[0] + '.pdf'
  basename = pdf_url.split('/')[-1]
  fname = os.path.join(Config.pdf_dir, basename)

  # try retrieve the pdf
  numtot += 1
  try:
    if not basename in have:
      download_pdf(pdf_url, fname)
      time.sleep(0.05 + random.uniform(0,0.1))
    else:
      print('[INFO] %s exists, skipping' % (fname, ))
    numok+=1
  except Exception as e:
    print('[ERROR] error downloading: ', pdf_url)
    print(e)
  print('[INFO] %d/%d of %d downloaded ok.' % (numok, numtot, len(db)))


def main():
    pools = multiprocessing.Pool(10)
    items = list(db.items())
    pools.map(process, items )

if __name__ == '__main__':
    main()
    print('final number of papers downloaded okay: %d/%d' % (numok, len(db)))

