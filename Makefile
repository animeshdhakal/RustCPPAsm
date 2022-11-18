CC = gcc
CXX = g++
ASMC = nasm
LD = gcc

SRCDIR := src
OBJDIR := target/release
BUILDDIR = target

CFLAGS =
CXXFLAGS =
ASFLAGS =
LDFLAGS = -pthread -ldl -lstdc++

rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

CSRC = $(call rwildcard,$(SRCDIR),*.c) 
CPPSRC = $(call rwildcard,$(SRCDIR),*.cpp) 
ASMSRC = $(call rwildcard,$(SRCDIR),*.asm)

OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.c_o, $(CSRC))
OBJS += $(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.cpp_o, $(CPPSRC))
OBJS += $(patsubst $(SRCDIR)/%.asm, $(OBJDIR)/%_asm.o, $(ASMSRC))

main: buildrust $(OBJS) link

link:
	@echo "Linking... $(OBJS)"
	@$(LD) $(OBJS) $(shell ls $(OBJDIR)/*.a) -o $(BUILDDIR)/main $(LDFLAGS)

buildrust:
	@echo "Compiling Rust"
	@cargo build --release

$(OBJDIR)/%.cpp_o: $(SRCDIR)/%.cpp
	@echo "Compiling C++ $<"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJDIR)/%.c_o: $(SRCDIR)/%.c
	@echo "Compiling C $<"
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/%_asm.o: $(SRCDIR)/%.asm
	@echo "Compiling ASM $<"
	@$(ASMC) $(ASFLAGS) -f elf64 $< -o $@ 

.PHONY: clean

clean:
	rm -rf $(BUILDDIR)/*
