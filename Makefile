CPANM_PATH = $(shell which cpanm || echo install-cpanm)
CARTON_PATH = $(shell which carton || echo install-carton)

all: build

$(CPANM_PATH):
	plenv install-cpanm

$(CARTON_PATH): | $(CPANM_PATH)
	cpanm --quiet --notest Carton

.PHONY: update
update: $(CARTON_PATH)
	carton update

local/bin/dzil: | $(CARTON_PATH)
	carton exec cpanm -l local --quiet --notest Dist::Zilla

.PHONY: authordeps
authordeps: | local/bin/dzil
	carton exec dzil authordeps | carton exec cpanm -l local --notest

.PHONY: installdeps
installdeps: authordeps
	carton exec dzil listdeps --author --missing --cpanm-version | carton exec xargs cpanm --quiet --local-lib local --notest

.PHONY: test
test:
	@carton exec dzil test

.PHONY: build
build:
	@carton exec dzil build
