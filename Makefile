CPANM_PATH = $(shell which cpanm || echo install-cpanm)
CARTON_PATH = $(shell which carton || echo install-carton)

all: build

$(CPANM_PATH):
	plenv install-cpanm

$(CARTON_PATH): | $(CPANM_PATH)
	cpanm --quiet --notest Carton

install-dzil: ${CARTON_PATH}
	carton exec cpanm -l local --notest Dist::Zilla

authordeps: install-dzil
	carton exec dzil authordeps | carton exec cpanm -l local --notest

installdeps: authordeps
	carton exec dzil listdeps --author --missing --cpanm-version | carton exec xargs cpanm --quiet --local-lib local --notest

update: | $(CARTON_PATH)
	carton update

test:
	@carton exec dzil test

build:
	@carton exec dzil build
