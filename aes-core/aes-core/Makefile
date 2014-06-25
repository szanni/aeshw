GHDL=ghdl
GHDLFLAGS=--ieee=synopsys
MOD = sbox sbox_tb sbox_inv sbox_inv_tb

all: $(MOD)

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

test: $(MOD)
	$(GHDL) -r $(GHDLRUNFLAGS) sbox_tb
	$(GHDL) -r $(GHDLRUNFLAGS) sbox_inv_tb

clean:
	rm -f $(MOD)

.PHONY: all clean
