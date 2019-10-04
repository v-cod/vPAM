PK3=zzz_svr_wrs.pk3
DED=/home/benno/src/aur/libcod/src/cod-1.5

$(PK3): maps/MP/gametypes/*.gsc
	git archive --format=zip --worktree-attributes -o $(PK3) $$(git stash create || echo HEAD)

clean:
	rm -f $(PK3)
	rm -f ~/.callofduty/main/$(PK3)
	rm -f ~/.callofduty/main/*.cfg

install: clean $(PK3)
	cp -f $(PK3) ~/.callofduty/main/
	cp -f *.cfg ~/.callofduty/main/

run: install
	$(DED)/cod_lnxded +set fs_basepath $(DED) +set dedicated 2 +logfile 2 +exec config_srv_base +exec config_srv_sd +devmap mp_ship +set sv_hostname WALRUS
