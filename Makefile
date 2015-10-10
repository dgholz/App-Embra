install-dzil:
	carton exec cpanm -l local --notest Dist::Zilla

authordeps: install-dzil
	carton exec dzil authordeps | carton exec cpanm -l local --notest

installdeps: authordeps
	carton exec dzil listdeps | carton exec cpanm -l local --notest

update:
	carton update

test:
	@carton exec dzil test
