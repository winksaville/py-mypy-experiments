# mypy experiments

The best way to have a package which can be used with `mypy` is
to have that package adhere to [PEP-561 specification](https://www.python.org/dev/peps/pep-0561/).
[Here](https://mypy.readthedocs.io/en/stable/installed_packages.html?highlight=pip%20561#making-pep-561-compatible-packages)
is a link to the documentation in mypy and [py-mouseevent](https://github.com/winksaville/py-mouseevent)
is a simple package that I created that `mouse.py` uses.

Another technique is to use `stubgen`, but I've come to the conclusion
its more trouble than its worth. To give you an idea, previously
in this repo I had `mouseevent.py` located locally:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments (master)
$ cat -n mouseevent.py 
     1	from typing import Optional, overload
     2	
     3	
     4	class MouseEvent:
     5	
     6	    _x1: int
     7	    _y1: int
     8	    _x2: int
     9	    _y2: int
    10	
    11	    @overload
    12	    def __init__(self, x1: int, y1: int) -> None:
    13	        ...
    14	
    15	    @overload
    16	    def __init__(self, x1: int, y1: int, x2: int, y2: int) -> None:
    17	        ...
    18	
    19	    def __init__(
    20	        self, x1: int, y1: int, x2: Optional[int] = None, y2: Optional[int] = None
    21	    ) -> None:
    22	        if x2 is None and y2 is None:
    23	            self._x1 = x1
    24	            self._y1 = y1
    25	        elif x2 is not None and y2 is not None:
    26	            self._x1 = x1
    27	            self._y1 = y1
    28	            self._x2 = x2
    29	            self._y2 = y2
    30	        else:
    31	            raise TypeError("Bad arguments")
```
And then used `stubgen mouseevent.py -o stubs` to generate `stubs/mouseevent.pyi`,
but likely will need modification. In particular in developing this
repo to test `mypy` usability I found out `stubgen` doesn't handle
`@overload` properly. And had to take the original file created by
`stubgen mouseevent.py -o stubs`:
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
And manually add `@overload` and remove the last `__init__`:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments
$ cat -n stubs/mouseevent.pyi 
     1	from typing import Optional, overload
     2	
     3	class MouseEvent:
     4	    @overload
     5	    def __init__(self, x1: int, y1: int) -> None: ...
     6	    @overload
     7	    def __init__(self, x1: int, y1: int, x2: int, y2: int) -> None: ...
     8	    #def __init__(self, x1: int, y1: int, x2: Optional[int]=..., y2: Optional[int]=...) -> None: ...
```
And then create `mypy.ini`:
```
(mypy-env) wink@3900x:~/prgs/python/projects/mypy-experiments (master)
$ cat -n mypy.ini
     1	[mypy]
     2	ignore_missing_imports = False 
     3	mypy_path = ./stubs
```
None of this is necessary if the package adheres to PEP-561, again
see [py-mouseevent](https://github.com/winksaville/py-mouseevent).
