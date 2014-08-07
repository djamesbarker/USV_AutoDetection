IDIR =../include
MEXIDIR ="C:\Program Files\MATLAB71\extern\include"
CC=gcc
AR=ar
ARFLAGS=rcs
CFLAGS=-I$(IDIR) -I$(MEXIDIR)

ODIR=obj
LDIR =../lib

LIBS=-lm

_DEPS = xbat.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJ = fast_min_max.o mex_util.o zero_crossings.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)
	
libxbat: $(OBJ)
	ar $(ARFLAGS) $@.a $^

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~ 
	
