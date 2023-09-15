# Minimal makefile for Sphinx documentation
#
root_dir:=$(realpath .)
# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?= -W -a
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help

# Instantiate CI rules
include ci/ci.mk

$(call ci, rstformat, $(SOURCEDIR))

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%:
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

ci: rst-format html spelling
.PHONY: ci
