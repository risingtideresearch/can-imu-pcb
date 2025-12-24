PROJECT_NAME := CAN_IMU
PCB_FILE := $(PROJECT_NAME).kicad_pcb
SCH_FILE := $(PROJECT_NAME).kicad_sch

GERBER_LAYERS := F.Cu,B.Cu,In1.Cu,In2.Cu,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,Edge.Cuts

VERSION := $(shell git describe --tags --always --dirty)
#VERSION := pre

OUTDIR := output

all: gerbers pos dimensions bom

.PHONY: clean
clean:
	rm -f output/*

$(OUTDIR): 
	mkdir -p $(OUTDIR)
	F.Cu,B.Cu,In1.Cu,In2.Cu,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,Edge.Cuts 

.PHONY: drc
drc:
	echo "Running DRC..."
	kicad-cli pcb drc $(PCB_FILE) --exit-code-violations

.PHONY: gerbers
gerbers: $(OUTDIR) drc
	kicad-cli pcb export gerbers -o $(OUTDIR) --no-protel-ext \
		-l $(GERBER_LAYERS) $(PCB_FILE)
	kicad-cli pcb export drill -o $(OUTDIR) $(PCB_FILE)
	cd $(OUTDIR); zip $(PROJECT_NAME)_$(VERSION)_gerbers.zip *.gbr *.drl $(PROJECT_NAME)-job.gbrjob:

.PHONY: pos
pos: $(OUTDIR) drc $(PCB_FILE)
	kicad-cli pcb export pos -o $(OUTDIR)/$(PROJECT_NAME)_$(VERSION).pos $(PCB_FILE)

.PHONY: dimensions
dimensions: $(OUTDIR) $(PCB_FILE)
	kicad-cli pcb export pdf -o $(OUTDIR)/$(PROJECT_NAME)_$(VERSION)_dimensions.pdf \
		--black-and-white -l Edge.Cuts,F.Paste,F.Silkscreen,User.1 $(PCB_FILE)

.PHONY: bom
bom: $(OUTDIR) $(SCH_FILE)
	kicad-cli sch export bom -o $(OUTDIR)/${PROJECT_NAME}_${VERSION}_BOM.csv \
    	--preset default $(SCH_FILE)

$(PROJECT_NAME).net: $(SCH_FILE)
	kicad-cli sch export netlist $(PROJECT_NAME).kicad_sch -o $(PROJECT_NAME).net

ibom: $(OUTDIR) $(PROJECT_NAME).net
	generate_interactive_bom --dest-dir $(OUTDIR) --name-format "%f_$(VERSION)_BOM" \
		--normalize-field-case --extra-data-file $(PROJECT_NAME).net \
		--show-fields "Value,Footprint,Mfg Part Number" --no-browser $(PCB_FILE) 

