.PHONY: clean distclean \
	pgo \
	pgo-firstpass pgo-secondpass \
	pgo-nanopi-m3-firstpass pgo-nanopi-m3-secondpass \
	nanopi-m3

DISTDIR=./bin/
BIN=CycloTracker

OBJ=CycloTracker.o \
	VideoOutput.o \
	ImageProcessor.o \
	ObjectCounter.o \
	ObjectLocator.o \
	ObjectTracker.o \
	PointTracker.o \
	TrackedObject.o \
	Sensors.o \
	Camera.o \
	CoordTransform.o \
	Utils.o

CFLAGS=--std=c++11 \
	   -Wall \
	   -Wextra \
	   -Wpedantic \
	   -Winit-self \
	   -Wmissing-braces \
	   -Wmissing-include-dirs \
	   -Wno-return-local-addr \
	   -Wswitch-default \
	   -Wmaybe-uninitialized \
	   -Wfloat-equal \
	   -Wundef \
	   -Wzero-as-null-pointer-constant \
	   -Wmissing-declarations \
	   -Winline \
	   -g \
	   -O2 \
	   `pkg-config --cflags opencv` \
	   -Werror=c++0x-compat \
	   -pthread
# -Wshadow 
# -Wdouble-promotion //colocar em maquinas 32bits . autconf?
#  https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

LDFLAGS=-lm \
	   `pkg-config --libs opencv` \
	   -lpthread


all:$(OBJ)
	@mkdir -p $(DISTDIR)
	@mkdir -p tmp
	g++ $(OBJ) -o $(DISTDIR)/$(BIN) $(LDFLAGS)

clean:
	rm -f $(DISTDIR)/$(BIN)
	rm -f $(OBJ)

%.o: %.cpp
	@echo CCXX $< -o $@ $(CFLAGS)
	@g++ -c $< -o $@ $(CFLAGS) 

PGO_FLAGS_1=-pg -fprofile-generate --coverage
pgo-firstpass: CFLAGS+=$(PGO_FLAGS_1)
pgo-firstpass: LDFLAGS+=$(PGO_FLAGS)
pgo-firstpass: clean all

PGO_FLAGS_2=-fprofile-correction -fprofile-use
pgo-secondpass: CFLAGS+=$(PGO_FLAGS_2)
pgo-secondpass: LDFLAGS+=$(PGO_FLAGS_2)
pgo-secondpass: clean all

pgo-nanopi-m3-firstpass: CFLAGS+=$(PGO_FLAGS_1)
pgo-nanopi-m3-firstpass: LDFLAGS+=$(PGO_FLAGS_1)
pgo-nanopi-m3-firstpass: clean nanopi-m3
	
pgo-nanopi-m3-secondpass: CFLAGS+=$(PGO_FLAGS_2)
pgo-nanopi-m3-secondpass: LDFLAGS+=$(PGO_FLAGS_2)
pgo-nanopi-m3-secondpass: clean nanopi-m3
	
distclean: clean
	rm -f *.gcda *.gcno *.gcov gmon.out


