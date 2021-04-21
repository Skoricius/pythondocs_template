# Makefile for Sphinx documentation

SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SPHINXGEN     ?= sphinx-apidoc
NBCONVERT     ?= jupyter
PYTHON        ?= python
PIP           ?= pip
SOURCEDIR     = .
BUILDDIR      = _build
TEMPLATESDIR  = templates
STATICDIR     = _static

example_notebooks := $(wildcard ../examples/*.ipynb)
example_names = $(foreach path, $(example_notebooks), $(basename $(notdir $(path))))
example_htmls = $(foreach name, $(example_names), $(STATICDIR)/examples/$(name).html)
example_rsts = $(foreach name, $(example_names), examples.$(name).rst)

html: conf.py index.rst install.rst examples.rst README.rst f3ast.rst $(example_rsts) $(example_htmls) .deps
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	touch "$(BUILDDIR)/html/.nojekyll"
	# echo "trimsh.org" > "$(BUILDDIR)/html/CNAME"
	mv "$(BUILDDIR)/html/_static/examples" "$(BUILDDIR)/html/examples" || true
	mv "$(BUILDDIR)/html/_static/images" "$(BUILDDIR)/html/images" || true
	# cp "$(STATICDIR)/favicon.ico" "$(BUILDDIR)/html/favicon.ico" || true

.deps: requirements.txt
	$(PIP) install -r requirements.txt
	$(PIP) freeze > .deps

README.rst: ../README.md .deps
	pandoc --from=gfm --to=rst --output=README.rst ../README.md

$(STATICDIR)/examples/%.html: ../examples/%.ipynb .deps
	mkdir -p "$(STATICDIR)/examples"
	$(NBCONVERT) nbconvert --to html --output $(abspath $@) $<

examples.%.rst: $(STATICDIR)/examples/%.html examples.template
	$(PYTHON) -c "open('$@', 'w').write(open('examples.template').read().format(name='$(*F)', url='$<'))"

f3ast.rst: .deps
	$(SPHINXGEN) -eTf -t "$(TEMPLATESDIR)" -o "$(SOURCEDIR)" ../f3ast

clean:
	rm -rvf "$(BUILDDIR)" "$(STATICDIR)/examples" examples.*.rst trimesh*.rst .deps README.rst

# # All other Sphinx builders
#%: conf.py index.rst install.rst examples.rst README.rst trimesh.rst $(example_rsts) $(example_htmls)
#	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
#
#.PHONY: %