OPENSCAD = openscad

SCADFILES = pegboard-hook.scad
STLFILES = $(SCADFILES:.scad=.stl)
DEPFILES = $(addsuffix deps,$(SCADFILES))

all: $(STLFILES)

%.stl: %.scad
	$(OPENSCAD) -d $<deps -m $(MAKE) -o $@ $<

clean:
	rm $(STLFILES) $(DEPFILES)

-include $(DEPFILES)
