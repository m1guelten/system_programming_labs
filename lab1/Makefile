
CXX = g++

CXXFLAGS = -std=c++11 -Wall

SRCDIR = .

OBJDIR = .

SOURCES = $(SRCDIR)/main.cpp $(SRCDIR)/Employee.cpp $(SRCDIR)/Database.cpp
HEADERS = $(SRCDIR)/Employee.h $(SRCDIR)/Database.h

OBJECTS = $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o,$(SOURCES))

EXECUTABLE = my_program

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(HEADERS)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(EXECUTABLE): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJECTS)

clean:
	rm -f $(OBJDIR)/*.o $(EXECUTABLE)

run: $(EXECUTABLE)
	./$(EXECUTABLE)

all: $(EXECUTABLE)

$(shell mkdir -p $(OBJDIR))

.PHONY: clean run all