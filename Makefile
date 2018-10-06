FC         = gfortran8
CFLAGS     = -Wall -Wl,-rpath=/usr/local/lib/gcc8/
LDFLAGS    = -I/usr/local/include/ -L/usr/local/lib/
LIBS       = -lX11

XLIB_SRC   = xlib.f90
XLIB_OBJ   = xlib.o

XPM_SRC    = xpm.f90
XPM_OBJ    = xpm.o

DIR        = examples

DRAWING    = drawing
EVENTS     = events
IMAGE      = image
MANDELBROT = mandelbrot
RAYCASTER  = raycaster
STARFIELD  = starfield
TEXT       = text
WINDOW     = window
WIREFRAME  = wireframe

.PHONY: all clean

all: $(XLIB_OBJ) $(XPM_OBJ)

xlib: $(XLIB_OBJ)

xpm: $(XPM_OBJ)

$(XLIB_OBJ):
	$(FC) -Wall -c $(XLIB_SRC)

$(XPM_OBJ):
	$(FC) -Wall -c $(XPM_SRC)

$(WINDOW): $(DIR)/$*.f90 $(XLIB_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(EVENTS): $(DIR)/$*.f90 $(XLIB_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(DRAWING): $(DIR)/$*.f90 $(XLIB_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(STARFIELD): $(DIR)/$*.f90 $(XLIB_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(WIREFRAME): $(DIR)/$*.f90 $(XLIB_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(MANDELBROT): $(DIR)/$*.f90 $(XLIB_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(TEXT): $(DIR)/$*.f90 $(XLIB_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(RAYCASTER): $(DIR)/$*.f90 $(XLIB_OBJ) $(XPM_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS) -lXpm

$(IMAGE): $(DIR)/$*.f90 $(XLIB_OBJ) $(XPM_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS) -lXpm

clean:
	rm *.mod $(XLIB_OBJ) $(XPM_OBJ) $(WINDOW) $(EVENTS) $(DRAWING) $(STARFIELD) $(WIREFRAME) $(MANDELBROT) $(TEXT) $(RAYCASTER) $(IMAGE)
