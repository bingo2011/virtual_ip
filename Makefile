.SUFFIXES:
.SUFFIXES: .c .o .net .lnx

CC = gcc
CFLAGS = -ggdb -Wall -Wextra -std=c99 -D_SVID_SOURCE -D_REENTRANT -D_XOPEN_SOURCE=500
LDFLAGS = -lpthread 

all: .depend A.lnx src.lnx node
#SOLUTION
all: .depend A.lnx src.lnx bigloopV.lnx cslab4A.lnx faulty.lnx node
#SOLUTION

UTIL=util/ipsum.c util/dbg.c util/htable.c
SRC=$(wildcard *.c)
HDR=$(wildcard *.h)
OBJ=$(SRC:.c=.o) $(UTIL:.c=.o)

node: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJ) $(LIBS)

A.lnx: AB.net net2lnx 
	./net2lnx $<
B.lnx: AB.net net2lnx 
	./net2lnx $<
faulty.lnx: faultyline.net net2lnx
	./net2lnx $<
src.lnx: loop.net net2lnx 
	./net2lnx $<

#SOLUTION
bigloopV.lnx: bigloop.net net2lnx
	./net2lnx $<
cslab4A.lnx: loopcslabs.net net2lnx
	./net2lnx $<
#SOLUTION

#SOLUTION
PROVIDED=net2lnx AB.net loop.net interface.h linklayer.h netlayer.h node.c parselinks.c parselinks.h rip.h runNode runNodeWin runNetwork
PUBLISHDIR=/course/cs168/pub/ip
provided: $(PROVIDED) .depend Makefile
	mkdir -p provided/util
	../redact --noclues SOLU""TION Makefile provided
	../redact --noclues SOLU""TION $(PROVIDED) provided
	cp util/* provided/util
	chmod +x provided/net2lnx provided/run*
publish: provided node
	rm -rf $(PUBLISHDIR)/provided
	mkdir -p $(PUBLISHDIR)
	cp -r provided $(PUBLISHDIR)/provided
	chmod -R a+rX $(PUBLISHDIR)
	cp node $(PUBLISHDIR)
	chmod a+rX $(PUBLISHDIR)/node
publishsol: 
	rm -rf $(PUBLISHDIR)/src
	mkdir -p $(PUBLISHDIR)/src
	make clean
	cp Makefile *.net *.c *.h run* net2lnx $(PUBLISHDIR)/src
	cp -r util $(PUBLISHDIR)/src/util
	chmod -R a+rX $(PUBLISHDIR)/src
#SOLUTION

clean:
	rm -f node $(OBJ) ?.lnx .depend *~
	rm -f dst.lnx dstR.lnx long1.lnx long2.lnx short.lnx src.lnx srcR.lnx
#SOLUTION
	rm -rf provided		# -rf is too dangerous in combo with macros
	rm -f bigloop?.lnx bigloopComp?.lnx cslab4?.lnx 
#SOLUTION

.depend:  $(HDR) $(SRC) $(UTIL)
	$(CC) $(CFLAGS) -M $(SRC) $(UTIL) | perl -pe 's+^(\S*).o: util/\1+util/$$1.o: util/$$1+' > .depend

ifeq (.depend,$(wildcard .depend))
include .depend
endif
