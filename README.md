# Vanilla Project Ares Mod

vPAM is continuing the legacy of the most popular competetive server mod for Call of Duty (2003). This project aims to be a more central hub to collect ideas and changes surrounding competetive gameplay.

## Building

Build the default vPAM:
```sh
make # or make z_svr_vpam.pk3
```

Build the WRS (EURO) mod:
```sh
make z_svr_wrs.pk3
```

## Running locally

Note: This will use and clean the `$HOME/.callofduty` directory.

A local server can be run if the server binaries are available. With the `cod_lnxded` located at `/srv/cod/cod_lnxded` use the following:
```
make BIN_DIR=/srv/cod ARGS='+g_gametype sd +set pam_mode match_aw' run
```

Or for WRS:
```
make BIN_DIR=/srv/cod ARGS='+g_gametype sd +set pam_mode match_aw' MOD=wrs run
```

## History

PAM was first conceived by Michael Berkowitz (GaretJax) and last released version [1.08](https://web.archive.org/web/20060205201311/http://garetgg.com/xoops/modules/mydownloads/) in 2005. reissue_/zyquist built his 1.11 (2015) rPAM version supposedly on a 1.09 ClanBase and 1.10 CyberGamer version.

Many people have made their own versions, ranging from color adjustments to rule changes. Thus many different versions have been circulating in the community.

vPAM does not build on rPAM, but on a widely circulating version probably based on the 1.09 ClanBase version. To prevent confusion with other versions, vPAM will continue at 1.12.


# Random resources

Patch info: https://web.archive.org/web/20050124024705/http://www.callofduty.com/patch/
Official Linux 1.5b patch: https://web.archive.org/web/20050125090626/http://download.activision.com/callofduty/cod-lnxded-bins-1.5b.tar.bz2
https://web.archive.org/web/20050404011412/http://inherent.infinityward.com/faq/

Punkbuster (guides): https://web.archive.org/web/20130217023131/http://www.evenbalance.com/index.php?page=support-cod.php

## Punkbuster

Get client values from server: `/rcon pb_sv_cvarval fs_homepath`
Get server values from client: `/rcon pb_cvarval pam_mode`

## Handy CVARS for debuggin

`arch`: architecture (?)
`fs_homepath`/`fs_basepath`: paths to game files.
`version`: show build information.
`username`: computer user

`g_logSync`: 1 to flush game log after print.
`logfile`: 1 to console log, 2 to flush after print. // 1 = buffer log, 2 = flush after each print
`dedicated`: "dedicated 1" is for lan play, "dedicated 2" is for inet public play
`developer`: 1 to print developer stuff.

## Commands

`set`: set cvar
`seta`: set cvar and flag as archive (saves to default config)
`sets`: set cvar and flag as serverinfo (shows up in server details for clients)
`setu`: flag as userinfo (sent to server on connect or change)
`reset`: unset cvar

`dumpuser`: show rate and snaps

`echo`: echo string.

## GSC

`takeallweapons`

`level` - round duration; resets on map_restart (e.g. round end in SD)
`game` - map duration; resets on exitLevel (map change)

fonts: bigfixed smallfixed default(?)
