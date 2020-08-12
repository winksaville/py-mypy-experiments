from typing import Optional, overload


class MouseEvent:

    _x1: int
    _y1: int
    _x2: int
    _y2: int

    @overload
    def __init__(self, x1: int, y1: int) -> None:
        ...

    @overload
    def __init__(self, x1: int, y1: int, x2: int, y2: int) -> None:
        ...

    def __init__(
        self, x1: int, y1: int, x2: Optional[int] = None, y2: Optional[int] = None
    ) -> None:
        if x2 is None and y2 is None:
            self._x1 = x1
            self._y1 = y1
        elif x2 is not None and y2 is not None:
            self._x1 = x1
            self._y1 = y1
            self._x2 = x2
            self._y2 = y2
        else:
            raise TypeError("Bad arguments")
