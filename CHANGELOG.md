# Change log

This project uses [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Anti fastshoot monitoring.
- Anti aimrun mechanism.
- Strat time lagbinding detection.
- p_allow_nades to control nades equipment.
- Death icon (like stock) on death pre-match.
- Configurable weapon configuration. (Secondary, change allied, or pre-set.)
- Configurable melee damage only. (Bash round.)
- Configurable overtime on tie.

### Changed
- Allow spawning during grace (strat).
- Ready up immediately from map start.
- No bomb plant pre-match.
- Rifle damage upped through script instead of weapon file.
- Halftime always at middle of rounds. (rounds / 2)
- Replaced scr_end_score and scr_end_round with stock equivalents (scr_sd).
- CHANGELOG, TODO and Makefile.

### Removed
- Removed pk3 checker.
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
