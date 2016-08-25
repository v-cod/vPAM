# Folders
DIR_GAMETYPES = maps/MP/gametypes/
DIR_WEAPONS   = weapons/

SRC_GSC = $(wildcard $(DIR_GAMETYPES)*.gsc)
SRC_TXT = $(wildcard $(DIR_GAMETYPES)*.txt)
SRC_WP  = $(wildcard $(DIR_WEAPONS)*/*)

PK3 = zzz_svr_wrs.pk3

all: $(PK3)

run: $(PK3)
	cd "/c/Program Files (x86)/Call of Duty Server/" && \
	"/c/Program Files (x86)/Call of Duty Server/CoDMP" \
	+set developer 2 +set dedicated 2 +set rconpassword abcd +exec config_base +exec config_jump

$(PK3): $(SRC_GSC) $(SRC_TXT) $(SRC_WP)
	@echo "Building" $@
	@7z a -tzip $@ $(SRC_GSC) $(SRC_TXT) $(SRC_WP) > /dev/null
