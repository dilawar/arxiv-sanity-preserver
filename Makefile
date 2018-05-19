PYTHON:=$(shell which python3)
PYTHON=./venv/bin/python

all : buildsvm thumb cache

cache : ./make_cache.py
	$(PYTHON) $<

buildsvm : ./buildsvm.py analyze 
	$(PYTHON) $<

analyze : ./analyze.py parse_pdf
	echo "You may like to run 'make download' manually"
	$(PYTHON) $<

thumb : ./thumb_pdf.py 
	$(PYTHON) $<

fetch : ./fetch_papers.py ./fetch_papers_biorxiv.py
	$(PYTHON) $<
	$(PYTHON) ./fetch_papers_biorxiv.py

download : ./download_pdfs.py fetch 
	$(PYTHON) $<
	$(PYTHON) ./download_pdfs_bioarxive.py

parse_pdf : ./parse_pdf_to_text.py 
	$(PYTHON) $<

serve : ./serve.py
	$(PYTHON) $< --prod &
