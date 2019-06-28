CPANM_PATH = $(shell cpanm --version 2>&1 >/dev/null && which cpanm || echo install-cpanm)
CARTON_PATH = $(shell carton --version 2>&1 >/dev/null && which carton || echo install-carton)
build:

$(CPANM_PATH):
	plenv install-cpanm

$(CARTON_PATH): | $(CPANM_PATH)
	cpanm --quiet --notest Carton

cpanfile.snapshot: cpanfile | $(CARTON_PATH)
	carton install

.PHONY: update
update: cpanfile.snapshot
	carton update

local/bin/dzil: | $(CARTON_PATH)
	carton exec cpanm -l local --quiet --notest Dist::Zilla

.PHONY: authordeps
authordeps: cpanfile.snapshot | local/bin/dzil
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

.PHONY: smoke
smoke: installdeps
	@carton exec dzil smoke --release --author
