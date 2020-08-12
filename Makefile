
all:
	@echo "usage: make target"
	@echo "  targets:"
	@echo "  c:       Check using mypy"
	@echo "  r:       Run mouse"
	@echo "  f:       Format using isort, black and flake8"
	@echo "  g:       Generate stubs/mouseevent.pyi"
	@echo "  m:       Move ./mouseevent.pyi to stubs/"
	@echo "  o:       Move ./mouseevent.overload.pyi to stubs/mouseevent.pyi"

.PHONY: c
c:
	mypy mouse.py

.PHONY: r
r:
	python mouse.py

.PHONY: f
f:
	isort *.py
	black *.py
	flake8 *.py

.PHONY: g
g:
	stubgen mouseevent.py -o stubs

.PHONY: m
m:
	cp mouseevent.pyi stubs/

.PHONY: o
o:
	cp mouseevent.overload.pyi stubs/mouseevent.pyi

