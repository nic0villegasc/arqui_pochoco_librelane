# Run inside nix-shell, from this folder.   make  -> list of targets
PDK_ROOT ?= $(HOME)/arqui_pochoco_soc/gf180mcu
export PDK_ROOT
ENV = . scripts/env.sh &&

help:
	@echo "  make synth   synthesize the RTL with Yosys  -> out/pochoco_soc.nl.v"
	@echo "  make gui     open the OpenROAD GUI (then: source scripts/steps/01_load.tcl, 02_..., etc.)"
	@echo "  make place   all steps at once, no GUI      -> out/pochoco_soc.placed.odb"
	@echo "  make clean   delete out/"

synth:
	$(ENV) yosys -c scripts/01_synth.tcl > out/yosys.log 2>&1; grep "Chip area" out/stat_mapped.rpt
gui:
	$(ENV) openroad -gui
place: synth
	$(ENV) openroad -exit -no_splash scripts/02_place.tcl 2>&1 | tail -5
clean:
	rm -rf out
.PHONY: help synth gui place clean
