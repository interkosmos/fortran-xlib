.POSIX:

FC      = gfortran
AR      = ar
PREFIX  = /usr/local
FFLAGS  = -Wall -fmax-errors=1 -fcheck=all
LDFLAGS = -I$(PREFIX)/include/ -L$(PREFIX)/lib/
LDLIBS  = -lX11
ARFLAGS = rcs
TARGET  = libfortran-xlib.a
DIR     = examples

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

all: $(TARGET)

$(TARGET):
	$(FC) $(FFLAGS) -c src/xlib.f90
	$(FC) $(FFLAGS) -c src/xpm.f90
	$(AR) $(ARFLAGS) $(TARGET) xlib.o xpm.o

$(WINDOW): $(DIR)/$(WINDOW)/$(WINDOW).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(EVENTS): $(DIR)/$(EVENTS)/$(EVENTS).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(DRAWING): $(DIR)/$(DRAWING)/$(DRAWING).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(STARFIELD): $(DIR)/$(STARFIELD)/$(STARFIELD).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(WIREFRAME): $(DIR)/$(WIREFRAME)/$(WIREFRAME).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(MANDELBROT): $(DIR)/$(MANDELBROT)/$(MANDELBROT).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(TEXT): $(DIR)/$(TEXT)/$(TEXT).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(RAYCASTER): $(DIR)/$(RAYCASTER)/$(RAYCASTER).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS) -lXpm

$(IMAGE): $(DIR)/$(IMAGE)/$(IMAGE).f90 $(XLIB_OBJ) $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS) -lXpm

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi 
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e $(DRAWING) ]; then rm $(DRAWING); fi
	if [ -e $(EVENTS) ]; then rm $(EVENTS); fi
	if [ -e $(IMAGE) ]; then rm $(IMAGE); fi
	if [ -e $(MANDELBROT) ]; then rm $(MANDELBROT); fi
	if [ -e $(RAYCASTER) ]; then rm $(RAYCASTER); fi
	if [ -e $(STARFIELD) ]; then rm $(STARFIELD); fi
	if [ -e $(TEXT) ]; then rm $(TEXT); fi
	if [ -e $(WINDOW) ]; then rm $(WINDOW); fi
	if [ -e $(WIREFRAME) ]; then rm $(WIREFRAME); fi
