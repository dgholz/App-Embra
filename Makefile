CPANM := $(shell command -v cpanm 2> /dev/null)

all: build

install-carton:
ifndef CPANM
	plenv install-cpanm
endif
	cpanm Carton

install-dzil: install-carton
	carton exec cpanm -l local --notest Dist::Zilla

authordeps: install-dzil
	carton exec dzil authordeps | carton exec cpanm -l local --notest

installdeps: authordeps
	carton exec dzil listdeps --author --missing --cpanm-version | carton exec xargs cpanm --quiet --local-lib local --notest

update: | install-carton
	carton update

test:
	@carton exec dzil test

build:
	@carton exec dzil build
