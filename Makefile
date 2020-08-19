# Directory containing cod_lnxded.
BIN_DIR ?= ../cod/out
# Directory containing CoDMP.exe
WINE_DIR ?= ~/.wine/drive_c/Program\ Files\ \(x86\)/Call\ of\ Duty\ Server
# Commandline added to server start.
ARGS ?= 
MAP ?= mp_harbor
# Mod to build: vpam or wrs.
MOD ?= vpam

outfile = z_svr_$(MOD).pk3
homepath = ~/.callofduty


SRC_FILES = $(shell find src/ -type f)
PAM_FILES = $(shell find pam/ -type f)
WRS_FILES = $(shell find wrs/ -type f)

z_svr_vpam.pk3: $(SRC_FILES) $(PAM_FILES)
	cd src/; zip -r ../$@ $(SRC_FILES:src/%=%)
	cd pam/; zip -r ../$@ $(PAM_FILES:pam/%=%)

z_svr_wrs.pk3: $(SRC_FILES) $(WRS_FILES)
	cd src/; zip -r ../$@ $(SRC_FILES:src/%=%)
	cd wrs/; zip -r ../$@ $(WRS_FILES:wrs/%=%)

.PHONY: clean
clean:
	rm $(outfile)


# Linux
.PHONY: run
run: install
	HOMEPATH="$$homepath" BINDIR="$$BIN_DIR" ./run \
		+set dedicated 2 +set logfile 2 +set g_logSync 1 \
		$(ARGS) \
		+devmap $(MAP)

.PHONY: install
install: $(outfile)
	rm -rf $(homepath)/main/

	mkdir --parents $(homepath)/main/
	cp $(outfile) $(homepath)/main/
	cp -r cfg $(homepath)/main/


# Wine (to run Windows server under Linux)
.PHONY: run-wine
run-wine: install-wine
	BASEPATH="$$WINE_DIR" ./run-wine \
		+set dedicated 2 +set logfile 2 +set g_logSync 1 \
		$(ARGS) \
		+devmap $(MAP)

.PHONY: install-wine
install-wine: $(outfile)
	rm -f $(WINE_DIR)/main/z_*.pk3
	rm -f $(WINE_DIR)/main/*.cfg
	rm -f $(WINE_DIR)/main/*.log
	rm -rf $(WINE_DIR)/main/cfg/

	cp $(outfile) $(WINE_DIR)/main/
	cp -r cfg $(WINE_DIR)/main/
