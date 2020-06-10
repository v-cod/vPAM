# Directory containing cod_lnxded.
BIN_DIR ?= ../cod/out
# Commandline added to server start.
ARGS ?= 

outfile = z_svr_wrs.pk3
homepath = ~/.callofduty
cmdline = \
	+set dedicated 2 \
	+set logfile 2 +set g_logSync 1 \
	+set rconPassword a


$(outfile): maps/MP/gametypes/*.gsc rules/*.gsc
	zip -r $@ $^

.PHONY: clean
clean:
	rm $(outfile)

.PHONY: run
run: install
	HOMEPATH="$$homepath" BINDIR="$$BIN_DIR" ./run \
		$(cmdline) \
		$(ARGS) \
		+devmap mp_harbor

.PHONY: install
install: $(outfile)
	rm -rf $(homepath)/main/
	mkdir --parents $(homepath)/main/
	cp $(outfile) $(homepath)/main/

.PHONY: uninstall
uninstall:
	rm $(homepath)/main/$(outfile)
