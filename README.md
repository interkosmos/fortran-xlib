# fortran-xlib: Fortran 2003 Interfaces to Xlib
A collection of ISO C binding interfaces to Xlib for Fortran 2003. Currently,
only a subset of Xlib is implemented. In order to work with XPM files,
interfaces to `libxpm` are included.

## Build
Build the interface bindings with:

```
$ make
```

Then, link your Fortran applications against `libfortran-xlib.a -lX11`.
Or, run *fpm* instead:

```
$ fpm build --profile release
```

The *fpm* script does not build any examples. You can add *fortran-xlib* as a
*fpm* dependency:

```toml
[dependencies]
fortran-xlib = { git = "https://github.com/interkosmos/fortran-xlib.git" }
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
$ gfortran -I/usr/local/include/ -L/usr/local/lib/ -o window examples/window/window.f90 libfortran-xlib.a -lX11
```

## Licence
ISC
