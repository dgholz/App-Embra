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
	carton exec dzil authordeps --missing --cpanm-version | carton exec xargs cpanm --quiet --local-lib local --notest

.PHONY: build
build: authordeps
	@carton exec dzil build

.PHONY: installdeps
installdeps: authordeps
	carton exec dzil listdeps --author --missing --cpanm-version | carton exec xargs cpanm --quiet --local-lib local --notest

.PHONY: test
test: installdeps
	@carton exec dzil test
