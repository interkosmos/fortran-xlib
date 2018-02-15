FC        = gfortran8
CFLAGS    = -fcheck=all -ffast-math -funroll-loops -Ofast -march=native -Wl,-rpath=/usr/local/lib/gcc8/
LDFLAGS   = -I/usr/local/include/ -L/usr/local/lib/
LIBS      = -lX11
SOURCE    = xlib.f90
OBJ       = xlib.o

DIR       = examples
WINDOW    = window
EVENTS    = events
DRAWING   = drawing
STARFIELD = starfield

all: $(OBJ)

$(OBJ):
	$(FC) -c $(SOURCE)

$(WINDOW): $(DIR)/$*.f90 $(OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(EVENTS): $(DIR)/$*.f90 $(OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(DRAWING): $(DIR)/$*.f90 $(OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

$(STARFIELD): $(DIR)/$*.f90 $(OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS) $(LIBS)

.PHONY: clean

clean:
	rm *.mod $(OBJ) window events drawing starfield
