# Call of Duty mod


## Competetive ideas

Additional:

- Fix deletePlacedEntity("mpweapon_kar98ksniper"); bug in _teams.gsc
- Fast shooting detection.
- Fix strat time lag bind bug.
- Warmup with deathmatch spawns.
- Detect disallowed jumps.
- Bash for side/map.
- Memorize result from previous game.
- Timeout rules.
- Force demo (?).
- Vote/veto for map(s) pre-game.
- No weapon menu on match half (if no choice).
- Restart on empty server.

##  Project Ares Mod:

- Ready-up phase.
- Overtime.
- Switch teams in half.
- Strat time (configurable).
- Players left alive (configurable).
- Round end score display.
- Drop no weapons for snipers (configurable).
- Hit blip.
- pk3 files check.
- Black spectator screen (configurable).
- Re-play draws (configurable).
- Configurable bomb plant timings.
- Congfigurable MG42 removal.
- Configurable pistol.
- Configurable nade count.
- Configurable maximum snipers/MGs.
- Bomb defusal time bug fix (defuse on 10 still explodes).

## Random resources

Patch info: https://web.archive.org/web/20050124024705/http://www.callofduty.com/patch/
Official Linux 1.5b patch: https://web.archive.org/web/20050125090626/http://download.activision.com/callofduty/cod-lnxded-bins-1.5b.tar.bz2
https://web.archive.org/web/20050404011412/http://inherent.infinityward.com/faq/

Punkbuster (guides): https://web.archive.org/web/20130217023131/http://www.evenbalance.com/index.php?page=support-cod.php

### Punkbuster

Get user values: `/rcon pb_sv_cvarval fs_homepath`

### Cvars

`arch`: architecture (?)
`fs_homepath`/`fs_basepath`: paths to game files.
`version`: show build information.
`username`: computer user

`g_logSync`: 1 to flush game log after print.
`logfile`: 1 to console log, 2 to flush after print. // 1 = buffer log, 2 = flush after each print
`dedicated`: "dedicated 1" is for lan play, "dedicated 2" is for inet public play
`developer`: 1 to print developer stuff.

### Commands

`set`: set cvar
`seta`: set cvar and flag as archive (saves to default config)
`sets`: set cvar and flag as serverinfo (shows up in server details for clients)
`setu`: flag as userinfo (sent to server on connect or change)
`reset`: unset cvar

`dumpuser`: show rate and snaps

`echo`: echo string.

### GSC

`takeallweapons`

`level` - round duration; resets on map_restart (e.g. round end in SD)
`game` - map duration; resets on exitLevel (map change)

fonts: bigfixed smallfixed default(?)
