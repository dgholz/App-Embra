
installdeps: authordeps
	carton exec dzil listdeps | carton exec cpanm -l local --notest

authordeps:
	carton exec cpanm -l local Dist::Zilla --notest
	carton exec dzil authordeps | carton exec cpanm -l local --notest

update:
	carton update

test:
	@carton exec dzil test
