# f03xlib
An `iso_c_binding` interface to Xlib for Fortran 2003/2008.

## Build
You can use the provided Makefile to compile everything. Build the interface with:
```
$ make
```
Or run your favourite Fortran compiler directly:
```
$ gfortran8 -c xlib.f90
```

## Examples
Example programmes utilising the interface can be found in the directory `examples`:

* `window.f90` displays a simple window.
* `events.f90` captures X11 events.
* `drawing.f90` draws some shapes on the window.
* `starfield.f90` flys through a starfield.
* `wireframe.f90` renders a wire-frame model of a Tie Fighter.

Build them with BSD make:
```
$ make window
$ make events
$ make drawing
$ make starfield
$ make wireframe
```

Without BSD make, compile the examples manually, for instance:
```
$ gfortran8 -o window -Wl,-rpath=/usr/local/lib/gcc8/ -I/usr/local/include/ -L/usr/local/lib/ examples/window.f90 xlib.o -lX11
```

## Licence
ISC
