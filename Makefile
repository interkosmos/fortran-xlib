FC         = gfortran8
RPATH      = -Wl,-rpath=/usr/local/lib/gcc8/
FFLAGS     =  $(RPATH) -Wall -fmax-errors=1 -fcheck=all
LDFLAGS    = -I/usr/local/include/ -L/usr/local/lib/
LDLIBS     = -lX11

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
	$(FC) $(FFLAGS) -c $(XLIB_SRC)

$(XPM_OBJ):
	$(FC) $(FFLAGS) -c $(XPM_SRC)

$(WINDOW): $(DIR)/$(WINDOW)/$*.f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(EVENTS): $(DIR)/$(EVENTS)/$*.f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(DRAWING): $(DIR)/$(DRAWING)/$*.f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(STARFIELD): $(DIR)/$(STARFIELD)/$*.f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(WIREFRAME): $(DIR)/$(WIREFRAME)/$*.f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(MANDELBROT): $(DIR)/$(MANDELBROT)/$*.f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(TEXT): $(DIR)/$(TEXT)/$*.f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(RAYCASTER): $(DIR)/$(RAYCASTER)/$*.f90 $(XLIB_OBJ) $(XPM_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS) -lXpm

$(IMAGE): $(DIR)/$(IMAGE)/$*.f90 $(XLIB_OBJ) $(XPM_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS) -lXpm

clean:
	rm *.mod $(XLIB_OBJ) $(XPM_OBJ) $(WINDOW) $(EVENTS) $(DRAWING) $(STARFIELD) $(WIREFRAME) $(MANDELBROT) $(TEXT) $(RAYCASTER) $(IMAGE)
