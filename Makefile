.POSIX:

FC      = gfortran
PREFIX  = /usr/local
FFLAGS  = -Wall -fmax-errors=1 -fcheck=all
LDFLAGS = -I$(PREFIX)/include/ -L$(PREFIX)/lib/
LDLIBS  = -lX11
DIR     = examples

XLIB_SRC = src/xlib.f90
XLIB_OBJ = xlib.o
XPM_SRC  = src/xpm.f90
XPM_OBJ  = xpm.o

.PHONY: all clean xlib xpm

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

$(WINDOW): $(DIR)/$(WINDOW)/$(WINDOW).f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(EVENTS): $(DIR)/$(EVENTS)/$(EVENTS).f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(DRAWING): $(DIR)/$(DRAWING)/$(DRAWING).f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(STARFIELD): $(DIR)/$(STARFIELD)/$(STARFIELD).f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(WIREFRAME): $(DIR)/$(WIREFRAME)/$(WIREFRAME).f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(MANDELBROT): $(DIR)/$(MANDELBROT)/$(MANDELBROT).f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(TEXT): $(DIR)/$(TEXT)/$(TEXT).f90 $(XLIB_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(RAYCASTER): $(DIR)/$(RAYCASTER)/$(RAYCASTER).f90 $(XLIB_OBJ) $(XPM_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS) -lXpm

$(IMAGE): $(DIR)/$(IMAGE)/$(IMAGE).f90 $(XLIB_OBJ) $(XPM_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS) -lXpm

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi 
	if [ -e $(XLIB_OBJ) ]; then rm $(XLIB_OBJ); fi
	if [ -e $(XPM_OBJ) ]; then rm $(XPM_OBJ); fi
	if [ -e $(DRAWING) ]; then rm $(DRAWING); fi
	if [ -e $(EVENTS) ]; then rm $(EVENTS); fi
	if [ -e $(IMAGE) ]; then rm $(IMAGE); fi
	if [ -e $(MANDELBROT) ]; then rm $(MANDELBROT); fi
	if [ -e $(RAYCASTER) ]; then rm $(RAYCASTER); fi
	if [ -e $(STARFIELD) ]; then rm $(STARFIELD); fi
	if [ -e $(TEXT) ]; then rm $(TEXT); fi
	if [ -e $(WINDOW) ]; then rm $(WINDOW); fi
	if [ -e $(WIREFRAME) ]; then rm $(WIREFRAME); fi
