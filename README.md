# f03xlib
An `iso_c_binding` interface to Xlib for Fortran 2003/2008. See directory
`examples/` for programmes utilising the interface.

## Build
Build the interface with your Fortran compiler:
```
$ gfortran8 -c xlib.f90
```
Then, compile and link your programme:
```
$ gfortran8 -o example -Wl,-rpath=/usr/local/lib/gcc8/ -I/usr/local/include/ -L/usr/local/lib/ -lX11 example.f90 xlib.o
```

## Licence
ISC
