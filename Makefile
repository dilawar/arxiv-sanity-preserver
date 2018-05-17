PYTHON:=$(shell which python3)

all : analyze thumb cache

cache : ./make_cache.py
	$(PYTHON) $<

buildsvn : ./buildsvn.py analyze 
	$(PYTHON) $<

analyze : ./analyze.py parse_pdf
	$(PYTHON) $<

thumb : ./thumb.pdf fetch:
	$(PYTHON) $<

fetch : ./fetch_papers.py
	$(PYTHON) $<

make_pdf : fetch ./download_pdfs.py
	$(PYTHON) $<

parse_pdf : ./parse_pdf_to_text.py make_pdf
	$(PYTHON) $<
