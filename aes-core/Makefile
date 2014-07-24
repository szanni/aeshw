GHDL=ghdl
#GHDLFLAGS=--ieee=synopsys
MOD = types.o math.o sbox.o cipher inv_cipher key_expander cipher_tb inv_cipher_tb key_expander_tb

all: clean $(MOD)
	$(GHDL) -r $(GHDLRUNFLAGS) cipher_tb
	$(GHDL) -r $(GHDLRUNFLAGS) inv_cipher_tb
	$(GHDL) -r $(GHDLRUNFLAGS) key_expander_tb

%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

clean:
	rm -f $(MOD)

.PHONY: all clean
