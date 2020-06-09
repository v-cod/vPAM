# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Anti fastshoot monitoring.
- Anti aimrun mechanism.
- Anti speeding mechanism.
- Strat time lagbinding detection.
- p_allow_nades to control nades equipment.
- Death icon (like stock) on death pre-match.
- Configurable weapon configuration. (Secondary, change allied, or pre-set.)
- Configurable melee damage only. (Bash round.)
- Configurable overtime on tie.
- Configurable accent color for mod messages.

### Changed
- Allow spawning during grace (strat).
- Ready up immediately from map start.
- No bomb plant pre-match.
- Rifle damage upped through script instead of weapon file.
- Halftime always at middle of rounds. (rounds / 2)
- Replaced scr_end_score and scr_end_round with stock equivalents (scr_sd).
- PK3 checker prints checksum of all paks.
- CHANGELOG, TODO and Makefile.

### Removed
- Removed feature to give spectator black screen.
- 'Check Sniper' functionality; wasn't used or useful.
- Removed feature to allow dropping second weapon.
- Removed superfluous 'nade refill' and 'strat' pam_mode.
- Removed ready up disconnected logic.
- Removed scr_force_bolt_rifles (in favour of more advanced weapon picking).
- Removed nade count settings.
- Removed unused PAM sounds.
- Removed score-based halftime and second half score limit.
- Printing sv_pure switch.


## [1.08] - 2005-05-01

### Added
- Added strat mode (\rcon set pam_mode strat). AUTOMATICALLY TURNS SV_CHEATS ON! Also auto-replentishes grenade ammo and has NO timelimit.
- Added yet MORE pam_modes and edited MORE rules. lol.
- Added a cvar (scr_allow_pistol) to enable/disable pistols.

### Changed
- Changed the 'drop weapon' button to USE rather than bash.
- Reduced the amount of time required to hold the USE button to drop a secondary weapon by about half a second.

### Fixed
- Fixed bug that was removing the 'player ready' symbol when he participates in Ready-Up killing and respawns.
- Fixed an exploit where you could NOT choose a new weapon at halftime and keep the weapon you had at the end of the 1st half.
- Fixed a bug that could cause thes server to crash after all players leave.
- Fixed a bug/exploit in weapon drop that would allow you to drop all/any of your weapons.


## [1.08-beta.4]

### Added
- Experimental Read-Up killing script. Players who want to kill can, but players who choose not to participate cannot be damaged. You choose to participate by shooting or attempting to damage anyone.

### Changed
- Returned the amount of time players have to collect weapons after a round to 5 seconds (was 4 seconds in previous Betas)
- Re-worked non-Strat-Time mode such that the Grace Period works as it always had before.
- A return of the now infamous colon.

### Fixed
- Fixed the round timer to end when the clock runs out.


## [1.08-beta.3]

### Added
- More edits to rule files (7 second strat-time).

### Changed
- Moved 'Explosives Planted' down to the bottom of the screen and made it smaller.

### Fixed
- Fixed an exploit where a player could /kill in strat time and go into GOD mode.
- Fixed a potential exploit where someone may be able to re-connect during strat time and not be held still.


## [1.08-beta.2]

### Added
- The server will not set a round timer unless there are two teams (round will never end).
- Added cvar to hold players still during strat time (scr_strat_time [0 / 1])
- Added cvar to allow secondary weapon drops (scr_allow_weapon_drops [0 / 1]).

### Changed
- Corrected some rule files.
- Changed bash_round to have no round timer.
- Grace Period is no longer PART of the round length. Grace period counts down then the Round Timer starts.
- Modified the weapon limit script to count ONLY the primary weapon in the weapon limits (secondary 'pick-up' weapons are not counted in totals).
- Moved many HUD elements around to satisfy those who just could not live without the lagometer (?!?!)

### Removed
- Removed some remnants mentioning 'UO' in the scripts.

### Fixed
- Fixed a bug that was preventing a single player in a server from being able to interact with the menu.
- Fixed a bug that allowed a player to switch teams on his/her own after a match had started.
- Fixed a bug in the weapon limit script that would count an axis weapon held by the allies against the total limit for the axis (and vice-versa).
- Fixed a bug that was preventing OT rules from getting loaded in several pam_modes.


## [1.08-beta.1]

### Added
- Integrated PAM UO's Ready-Up into PAM
- Added cvars to control nade spawn counts based on weapon type:
  scr_rifle_nade_count
  scr_smg_nade_count
  scr_mg_nade_count
  scr_sniper_nade_count
- Added a cvar to control whether or not the MG42 (stationary machine guns) are spawned on the maps (scr_allow_mg42).
- Added scr_force_bolt_rifles cvar. This will force all Americans and Russians to spawn with the Nagant Rifle, British to spawn with the Enfield Rifle, and Germans to spawn with the Kar98 Rifle DESPITE whatever weapon they choose.
- Added/modified/corrected several leagues' rules.
- Added a pam_mode for BASH rounds (pam_mode "bash_round"). This will only allow damage to be given to other players by bashing them with a pistol. All other weapons are removed. Once the bash round is over and side-selection has been won, you can then move on to your normal pam_modes.
- Added the server PK3 checker that will inform ALL players if there are non-stock PK3 files on the server.
- Ported over PAM UO scoreboard to vPAM.

### Changed
- Optimizations of script:
  Moved League Logos into Rule files
  Rebuilt Weapon Limit Script to be much more efficient
- Made weapon limits such that setting a weapon limit to 0 or 99 would DISABLE the weapon limit checks for that weapon. This can prevent PAM from automatically turning on weapons that the server admin is trying to disable.
- Rebuilt the way OT is done so that it is more versatile and OT can be called up from rcon if necessary.
- Weapon-Limit CVAR CHANGE: I have combined allied and axis cvars into 1 generic cvar. sv_alliedSniperLimit and sv_axisSniperLimit becomes simply sv_SniperLimit. I have never seen ANYONE set up different limits for different teams in matches or in pub, and this just makes it easier to use. The same is true for all Weapon Limit cvars (smg & mg).
- Changed TWL pam_modes to be more user-friendly. They are now: twl_ladder, twl_league, and twl_rifles.
- Re-enabled Stock Axis/Allies Win Announcement for Round Wins.

### Removed
- Removed Auto-Demo completely.
- Removed all Scrim modes as they are no longer needed
- No more killing during warm-up.
