# Directory containing cod_lnxded.
BIN_DIR ?= ~/opt/cod
# Directory containing CoDMP.exe or CoDUOMP.exe.
WINE_DIR ?= ~/opt/cod-windows

# Commandline added to server start.
ARGS ?= 
MAP ?= mp_harbor

# Mod to build: vpam or wrs.
MOD ?= vpam

outfile = z_svr_$(MOD).pk3
homepath = ~/.callofduty

ifndef UO
main_dirname = main
else
main_dirname = uo
endif

SRC_FILES = $(shell find src/ -type f)
MOD_FILES = $(shell find $(MOD)/ -type f)

$(outfile): $(SRC_FILES) $(MOD_FILES)
	cd src/    && zip -r ../$@ $(SRC_FILES:src/%=%)
	cd $(MOD)/ && zip -r ../$@ $(MOD_FILES:$(MOD)/%=%)

.PHONY: clean
clean:
	rm $(outfile)

.PHONY: run
.PHONY: install

# Linux
ifndef WINE
run: install
	HOMEPATH="$$homepath" BINDIR="$$BIN_DIR" ./run \
		+set dedicated 2 +set logfile 2 +set g_logSync 1 \
		$(ARGS) \
		+devmap $(MAP)

install: $(outfile)
	rm -rf $(homepath)/$(main_dirname)/

	mkdir --parents $(homepath)/$(main_dirname)/
	cp $(outfile) $(homepath)/$(main_dirname)/
	cp -r cfg $(homepath)/$(main_dirname)/

# Wine (to run Windows server under Linux)
else
run: install
	BASEPATH="$$WINE_DIR" ./run-wine \
		+set dedicated 2 +set logfile 2 +set g_logSync 1 \
		$(ARGS) \
		+devmap $(MAP)

install: $(outfile)
	rm -f $(WINE_DIR)/$(main_dirname)/z_*.pk3
	rm -f $(WINE_DIR)/$(main_dirname)/*.cfg
	rm -f $(WINE_DIR)/$(main_dirname)/*.log
	rm -rf $(WINE_DIR)/$(main_dirname)/cfg/

	cp $(outfile) $(WINE_DIR)/$(main_dirname)/
	cp -r cfg $(WINE_DIR)/$(main_dirname)/
endif
