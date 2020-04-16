PK3=z_svr_dlogics_wrs.pk3
BIN_DIR ?= ../out
PARAM ?= +map mp_harbor

$(PK3): maps/MP/gametypes/*.gsc
	git archive --format=zip --worktree-attributes -o $(PK3) $$(test -n "$$(git stash create)" && echo $$(git stash create) || echo HEAD)

clean:
	rm -f $(PK3)
	rm -f ~/.callofduty/main/*.pk3
	rm -f ~/.callofduty/main/*.cfg

install: clean $(PK3)
	cp -f $(PK3) ~/.callofduty/main/
	# cp -f *.cfg ~/.callofduty/main/

run: install
	$(BIN_DIR)/cod_lnxded +set fs_basepath $(BIN_DIR) +set dedicated 2 +set logfile 2 +set g_logSync 3 $(PARAM) +set rconPassword a
