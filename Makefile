PYTHON:=$(shell which python3)

all : buildsvm thumb cache

cache : ./make_cache.py
	$(PYTHON) $<

buildsvm : ./buildsvm.py analyze 
	$(PYTHON) $<

analyze : ./analyze.py parse_pdf
	$(PYTHON) $<

thumb : ./thumb_pdf.py fetch
	$(PYTHON) $<

fetch : ./fetch_papers.py
	$(PYTHON) $<

make_pdf : ./download_pdfs.py fetch
	$(PYTHON) $<

parse_pdf : ./parse_pdf_to_text.py make_pdf
	$(PYTHON) $<
