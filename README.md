# f03xlib
An `iso_c_binding` interface to Xlib for Fortran 2003/2008. See directory
`examples/` for programmes utilising the interface.

## Build
Build the interface with your favourite Fortran compiler:
```
$ gfortran8 -c xlib.f90
```
Then, compile and link your programme:
```
$ gfortran8 -o window -Wl,-rpath=/usr/local/lib/gcc8/ -I/usr/local/include/ -L/usr/local/lib/ examples/window.f90 xlib.o -lX11
```

## Licence
ISC
