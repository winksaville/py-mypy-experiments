
all:
	@echo "usage: make target"
	@echo "  targets:"
	@echo "  c:       Check using mypy"
	@echo "  r:       Run mouse"
	@echo "  f:       Format using isort, black and flake8"

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

