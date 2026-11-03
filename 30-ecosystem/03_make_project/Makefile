# Makefile - hand-written Fortran build with explicit module dependencies.
#
# Make does not know that main.o needs convert.mod; we must say so. The
# usual trick: make each object depend on the OBJECTS of the modules it
# uses (an object and its .mod are produced by the same compile).
# Tools such as makedepf90 or fortdepend generate these lines.

FC     ?= gfortran
FFLAGS ?= -std=f2023 -Wall -Wextra
OUT    ?= build

OBJS = $(OUT)/units.o $(OUT)/convert.o $(OUT)/main.o

$(OUT)/app: $(OBJS)
	$(FC) $(FFLAGS) $^ -o $@

$(OUT)/%.o: %.f90 | $(OUT)
	$(FC) $(FFLAGS) -J $(OUT) -c $< -o $@

# Module dependencies:
$(OUT)/convert.o: $(OUT)/units.o
$(OUT)/main.o:    $(OUT)/convert.o

$(OUT):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(OUT)
