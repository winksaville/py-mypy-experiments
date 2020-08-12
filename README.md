# mypy experiments

Stubgen does not seem to handle @overload properly. If
you generate a stub with `make g`:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ make g
stubgen mouseevent.py -o stubs
Processed 1 modules
Generated stubs/mouseevent.pyi
```
The result, `stubs/mouseevent.pyi`, is:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ cat -n stubs/mouseevent.pyi 
     1	from typing import Optional
     2	
     3	class MouseEvent:
     4	    def __init__(self, x1: int, y1: int) -> None: ...
     5	    def __init__(self, x1: int, y1: int, x2: int, y2: int) -> None: ...
     6	    def __init__(self, x1: int, y1: int, x2: Optional[int]=..., y2: Optional[int]=...) -> None: ...
```
If you then "check" by running `make c` which runs `mypy mouse.py`
you get the following errors:
```
$ make c
mypy mouse.py
stubs/mouseevent.pyi:5: error: Name '__init__' already defined on line 4
stubs/mouseevent.pyi:6: error: Name '__init__' already defined on line 4
mouse.py:9: error: Too many arguments for "MouseEvent"
Found 3 errors in 2 files (checked 1 source file)
make: *** [Makefile:13: c] Error 1
```
The first stab at fixing is to decorate the first two
__init__'s with @overload:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ cat -n mouseevent.overload.pyi 
     1	from typing import Optional, overload
     2	
     3	class MouseEvent:
     4	    @overload
     5	    def __init__(self, x1: int, y1: int) -> None: ...
     6	    @overload
     7	    def __init__(self, x1: int, y1: int, x2: int, y2: int) -> None: ...
     8	    def __init__(self, x1: int, y1: int, x2: Optional[int]=..., y2: Optional[int]=...) -> None: ...
```
You can use `make o` to copy it to `stubs/mouseevent.pyi` and
then run `make c` again:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ make o
cp mouseevent.overload.pyi stubs/mouseevent.pyi
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ make c
mypy mouse.py
stubs/mouseevent.pyi:8: error: An implementation for an overloaded function is not allowed in a stub file
Found 1 error in 1 file (checked 1 source file)
make: *** [Makefile:14: c] Error 1
```
We still have an error, this final error can be resolved
by commenting out the last __init__ at line 8, which is in
`./mouseevent.pyi` use `make m` to copy it to `stubs/mouseevent.pyi`
and then run `make c` again. Now all is well:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ make m
cp mouseevent.pyi stubs/
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ make c
mypy mouse.py
Success: no issues found in 1 source file
```
