all: blocking non-blocking

CXX = g++
CXXFLAGS = -std=c++11 -O2

serial: serial.C
	$(CXX) $(CXXFLAGS) -o life $<

blocking: life-blocking.C
	mpicxx -o life-blocking $<

non-blocking: life-nonblocking.C
	mpicxx -o life-nonblocking $<

clean:
	rm -f serial.o life
	rm -f life-blocking.o life-blocking
	rm -f life-nonblocking.o life-nonblocking