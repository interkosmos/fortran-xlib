# fortran-xlib: Fortran 2003 interfaces to Xlib
A collection of ISO C binding interfaces to Xlib for Fortran 2003. Currently,
only a subset of Xlib is implemented. In order to work with XPM files,
interfaces to libxpm are provided by `xpm.f90`.

## Build
Build the Xlib interfaces with:

```
$ make xlib
```

Or run your favourite Fortran compiler directly:

```
$ gfortran9 -c src/xlib.f90
```

Build the XPM interfaces with:

```
$ make xpm
```

## Examples
![Screen Shot](screenshot.png)

Example programs utilising the interfaces can be found in the directory
`examples/`:

* **drawing** draws some shapes on the window.
* **events** captures X11 events.
* **image** loads and displays an XPM image with transparency.
* **mandelbrot** draws a Mandelbrot set.
* **raycaster** projects a 2-D map into 3-D.
* **starfield** flys through a starfield.
* **text** outputs coloured text.
* **window** displays a simple window.
* **wireframe** renders a wire-frame model of a Tie Fighter.

Build them with `make <name>` or compile them manually, for instance:

```
$ gfortran -I/usr/local/include/ -L/usr/local/lib/ \
  -o window examples/window/window.f90 xlib.o -lX11
```

## Licence
ISC
