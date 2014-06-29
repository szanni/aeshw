GHDL=ghdl
#GHDLFLAGS=--ieee=synopsys
MOD = types.o cipher cipher_tb

all: clean $(MOD)
	$(GHDL) -r $(GHDLRUNFLAGS) cipher_tb

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

clean:
	rm -f $(MOD)

.PHONY: all clean
