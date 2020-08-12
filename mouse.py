from typing import Optional, Union, overload

from mouseevent import MouseEvent


def main() -> None:
    m1: MouseEvent = MouseEvent(7, 8)
    print(f"{vars(m1)=}")
    m2: MouseEvent = MouseEvent(9, 10, 11, 12)
    print(f"{vars(m2)=}")


if __name__ == "__main__":
    main()
