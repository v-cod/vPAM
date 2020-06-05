/**///////////////////////////**/
/**///     DO NOT EDIT     ///**/
/**///////////////////////////**/
cvars()
{
	// LABEL
	game["p_istr_label_left"] = &"basic";


	/// MATCH
	setCvar("p_ready", false);           // Require players to ready-up before starting match.
	setCvar("p_msg_1", "");              // Message(s) to inform player before ready-up.

	setCvar("p_bash", false);            // Only allow bash damage to be done.

	setCvar("p_replay_draw", true);      // Do not count rounds ending in a draw.
	setCvar("p_round_restart_delay", 10);// Time to wait before starting next round. Shows small scoreboard.

	setCvar("p_strat", false);           // Hold players still during grace period.

	setCvar("p_overtime_on_tie", false);
	setCvar("p_overtime_roundlimit", 4);


	/// WEAPONS
	setCvar("p_allow_pistol", true);  // Equip players with pistol.
	setCvar("p_allow_nades", true);   // Equip players with nades.
	setCvar("p_allow_MG42", true);    // Keep MG42s in the map.

	// Multiple values possible.
	// "default": Do not change weapon menu behaviour.
	// "opponent": Pick a second weapon from the enemy team.
	// "american", "british" or "russian": Same as "opponent", but change allied weapon menu to specified allies.
	// "<primary>" or "<primary> <secondary>": Fixed weapon loadout. E.g. "bar mp40" or "sten".
	setCvar("p_weapons", "default");


	// MISC
	setCvar("p_afs_time", 1.2); // Minimum rechamber time for rifles.
	setCvar("p_hud_alive", true); // Show amount of team players alive.


	/// STOCK
	// Set stock cvars to defaults. But overwrite some below.
	defaults();

	setCvar("scr_sd_roundlength", 2.5);  // Time length per S&D round.

	setCvar("g_deadchat", true);         // Living players can see dead players' chats.
	setCvar("scr_drawfriend", true);     // Draws a team icon over teammates.
	setCvar("scr_freelook", false);      // Free roaming after death.
	setCvar("scr_friendlyfire", false);  // Allow team damage.
	setCvar("scr_killcam", true);        // View killcam when killed by enemy player.
	setCvar("scr_spectateenemy", false); // Spectate the enemy team after death.
	setCvar("scr_teambalance", true);    // Keep amount of team players in balance.
}

// Set cvars to default 1.5 values.
defaults()
{
	// These values were given by the 'cvarlist' command on a default 1.5 server.
	// Some cvars are set by the server or are supposed to be set by server admins, so they are commented out.

	// setCvar("arch", "");
	setCvar("bg_debugWeaponAnim", "0");
	setCvar("bg_debugWeaponState", "0");
	setCvar("bg_fallDamageMaxHeight", "480");
	setCvar("bg_fallDamageMinHeight", "256");
	setCvar("bg_foliagesnd_fastinterval", "500");
	setCvar("bg_foliagesnd_maxspeed", "180");
	setCvar("bg_foliagesnd_minspeed", "40");
	setCvar("bg_foliagesnd_resetinterval", "500");
	setCvar("bg_foliagesnd_slowinterval", "1500");
	setCvar("bg_ladder_yawcap", "100");
	setCvar("bg_prone_yawcap", "85");
	setCvar("bg_swingSpeed", "0.2");
	setCvar("bg_viewheight_crouched", "40");
	setCvar("bg_viewheight_prone", "11");
	setCvar("bg_viewheight_standing", "60");
	setCvar("cg_bobAmplitudeDucked", "0.0075");
	setCvar("cg_bobAmplitudeProne", "0.03");
	setCvar("cg_bobAmplitudeStanding", "0.007");
	setCvar("cg_bobMax", "8");
	// setCvar("cl_freelook", "1");
	// setCvar("cl_languagewarnings", "0");
	// setCvar("cl_languagewarningsaserrors", "0");
	// setCvar("cl_mouseAccel", "0");
	// setCvar("cl_paused", "0");
	// setCvar("cl_running", "0");
	// setCvar("cl_xmodelcheck", "0");
	// setCvar("cm_noCurves", "0");
	// setCvar("cm_playerCurveClip", "1");
	// setCvar("com_animCheck", "0");
	// setCvar("com_expectedhunkusage", "40723840");
	// setCvar("com_hunkMegs", "128");
	// setCvar("com_introplayed", "0");
	// setCvar("com_maxfps", "85");
	// setCvar("com_recommendedSet", "1");
	// setCvar("com_speeds", "0");
	// setCvar("com_statmon", "0");
	// setCvar("dedicated", "2");
	// setCvar("developer", "0");
	// setCvar("developer_script", "0");
	// setCvar("fixedtime", "0");
	// setCvar("fs_basegame", "");
	// setCvar("fs_basepath", "");
	// setCvar("fs_cdpath", "");
	// setCvar("fs_copyfiles", "0");
	// setCvar("fs_debug", "0");
	// setCvar("fs_game", "");
	// setCvar("fs_homepath", "");
	// setCvar("fs_ignoreLozalized", "0");
	// setCvar("fs_restrict", "");
	// setCvar("g_allowVote", "1");
	// setCvar("g_allowVoteClientKick", "0");
	// setCvar("g_allowVoteDrawFriend", "0");
	// setCvar("g_allowVoteFriendlyFire", "0");
	// setCvar("g_allowVoteGameType", "1");
	// setCvar("g_allowVoteKick", "0");
	// setCvar("g_allowVoteKillCam", "0");
	// setCvar("g_allowVoteMap", "1");
	// setCvar("g_allowVoteMapRestart", "1");
	// setCvar("g_allowVoteMapRotate", "1");
	// setCvar("g_allowVoteTempBanClient", "0");
	// setCvar("g_allowVoteTempBanUser", "0");
	// setCvar("g_allowVoteTypeMap", "1");
	// setCvar("g_autodemo", "0");
	// setCvar("g_autoscreenshot", "0");
	// setCvar("g_banIPs", "");
	setCvar("g_bounds_height_standing", "70");
	setCvar("g_bounds_width", "30");
	setCvar("g_complaintlimit", "3");
	// setCvar("g_deadChat", "0");
	setCvar("g_debugAlloc", "0");
	setCvar("g_debuganim", "0");
	setCvar("g_debugBullets", "0");
	setCvar("g_debugDamage", "0");
	setCvar("g_debugLocDamage", "0");
	setCvar("g_debugMove", "0");
	setCvar("g_debugProneCheck", "0");
	setCvar("g_debugProneCheckDepthCheck", "1");
	setCvar("g_debugShowHit", "0");
	setCvar("g_dumpAnims", "-1");
	// setCvar("g_gametype", "sd");
	setCvar("g_gravity", "800");
	setCvar("g_inactivity", "0");
	setCvar("g_intermissionDelay", "1000");
	setCvar("g_knockback", "1000");
	setCvar("g_listEntity", "0");
	// setCvar("g_log", "");
	// setCvar("g_logSync", "0");
	setCvar("g_maxDroppedWeapons", "16");
	// setCvar("g_motd", "");
	setCvar("g_no_script_spam", "0");
	// setCvar("g_password", "");
	setCvar("g_ScoresBanner_Allies", "gfx/hud/hud@mpflag_russian.tga");
	setCvar("g_ScoresBanner_Axis", "gfx/hud/hud@mpflag_german.tga");
	setCvar("g_ScoresBanner_None", "gfx/hud/hud@mpflag_none.tga");
	setCvar("g_ScoresBanner_Spectators", "gfx/hud/hud@mpflag_spectator.tga");
	setCvar("g_scriptMainMenu", "");
	setCvar("g_smoothClients", "1");
	setCvar("g_speed", "190");
	setCvar("g_synchronousClients", "0");
	setCvar("g_TeamColor_Allies", ".75 .25 .25");
	setCvar("g_TeamColor_Axis", ".6 .6 .6");
	setCvar("g_TeamName_Allies", "MPSCRIPT_RUSSIAN");
	setCvar("g_TeamName_Axis", "MPSCRIPT_GERMAN");
	setCvar("g_timeoutBank", "180000");
	setCvar("g_timeoutlength", "90000");
	setCvar("g_timeoutRecovery", "10000");
	setCvar("g_timeoutsallowed", "0");
	setCvar("g_useGear", "1");
	setCvar("g_voiceChatsAllowed", "4");
	setCvar("g_weaponAmmoPools", "0");
	setCvar("g_weaponrespawn", "5");
	// setCvar("gamedate", "Nov 15 2004");
	// setCvar("gamename", "Call of Duty");
	// setCvar("journal", "0");
	// setCvar("logfile", "0");
	// setCvar("m_filter", "0");
	// setCvar("m_pitch", "0.022");
	// setCvar("mapname", "");
	// setCvar("net_ip", "");
	// setCvar("net_lanauthorize", "0");
	// setCvar("net_noudp", "0");
	// setCvar("net_port", "");
	// setCvar("net_profile", "0");
	// setCvar("net_qport", "");
	// setCvar("net_showprofile", "0");
	// setCvar("nextmap", "map_restart");
	// setCvar("pmove_fixed", "0");
	// setCvar("pmove_msec", "8");
	// setCvar("protocol", "6");
	// setCvar("r_uiFullScreen", "1");
	// setCvar("rconPassword", "");
	setCvar("scr_allow_bar", "1");
	setCvar("scr_allow_bren", "1");
	setCvar("scr_allow_enfield", "1");
	setCvar("scr_allow_fg42", "0");
	setCvar("scr_allow_kar98k", "1");
	setCvar("scr_allow_kar98ksniper", "1");
	setCvar("scr_allow_m1carbine", "1");
	setCvar("scr_allow_m1garand", "1");
	setCvar("scr_allow_mp40", "1");
	setCvar("scr_allow_mp44", "1");
	setCvar("scr_allow_nagant", "1");
	setCvar("scr_allow_nagantsniper", "1");
	setCvar("scr_allow_panzerfaust", "1");
	setCvar("scr_allow_ppsh", "1");
	setCvar("scr_allow_springfield", "1");
	setCvar("scr_allow_sten", "1");
	setCvar("scr_allow_thompson", "1");
	setCvar("scr_bel_alivepointtime", "10");
	setCvar("scr_bel_scorelimit", "50");
	setCvar("scr_bel_timelimit", "30");
	setCvar("scr_dm_scorelimit", "50");
	setCvar("scr_dm_timelimit", "30");
	setCvar("scr_drawfriend", "0");
	setCvar("scr_forcerespawn", "0");
	setCvar("scr_freelook", "1");
	setCvar("scr_friendlyfire", "0");
	setCvar("scr_killcam", "1");
	// setCvar("scr_layoutimage", "levelshots/layouts/hud@layout_mp_harbor");
	// setCvar("scr_motd", "");
	setCvar("scr_re_graceperiod", "15");
	setCvar("scr_re_roundlength", "4");
	setCvar("scr_re_roundlimit", "0");
	setCvar("scr_re_scorelimit", "10");
	setCvar("scr_re_showcarrier", "0");
	setCvar("scr_re_timelimit", "0");
	setCvar("scr_sd_graceperiod", "15");
	setCvar("scr_sd_roundlength", "4");
	setCvar("scr_sd_roundlimit", "0");
	setCvar("scr_sd_scorelimit", "10");
	setCvar("scr_sd_timelimit", "0");
	setCvar("scr_spectateenemy", "1");
	setCvar("scr_tdm_scorelimit", "100");
	setCvar("scr_tdm_timelimit", "30");
	setCvar("scr_teambalance", "0");
	// setCvar("sensitivity", "5");
	// setCvar("shortversion", "1.5");
	// setCvar("showdrop", "0");
	// setCvar("showpackets", "0");
	// setCvar("sv_allowAnonymous", "0");
	// setCvar("sv_allowDownload", "1");
	setCvar("sv_cheats", "0");
	// setCvar("sv_console_lockout", "0");
	setCvar("sv_disableClientConsole", "0");
	setCvar("sv_floodProtect", "1");
	// setCvar("sv_fps", "20");
	// setCvar("sv_hostname", "CoDHost");
	// setCvar("sv_keywords", "");
	// setCvar("sv_kickBanTime", "300");
	// setCvar("sv_killserver", "0");
	// setCvar("sv_mapname", "");
	// setCvar("sv_mapRotation", "");
	// setCvar("sv_mapRotationCurrent", "");
	// setCvar("sv_maxclients", "20");
	// setCvar("sv_maxPing", "0");
	// setCvar("sv_maxRate", "0");
	// setCvar("sv_minPing", "0");
	// setCvar("sv_onlyVisibleClients", "0");
	// setCvar("sv_packet_info", "0");
	// setCvar("sv_padPackets", "0");
	// setCvar("sv_pakNames", "pakb paka pak9 pak8 pak6 pak5 pak4 pak3 pak2 pak1 pak0");
	// setCvar("sv_paks", "-1730142177 487517159 1622099944 -858314597 1252304247 77111478 -1825805837 918160098 616334813 1265884747 1048127331 ");
	// setCvar("sv_paused", "0");
	// setCvar("sv_privateClients", "0");
	// setCvar("sv_privatePassword", "");
	// setCvar("sv_punkbuster", "0");
	setCvar("sv_pure", "1");
	// setCvar("sv_reconnectlimit", "3");
	// setCvar("sv_referencedPakNames", "main/pakb main/pak9 main/pak8 main/pak5 main/pak4 main/pak1 main/pak0");
	// setCvar("sv_referencedPaks", "-1730142177 1622099944 -858314597 77111478 -1825805837 1265884747 1048127331 ");
	// setCvar("sv_running", "1");
	// setCvar("sv_serverid", "16");
	// setCvar("sv_serverRestarting", "0");
	// setCvar("sv_showAverageBPS", "0");
	// setCvar("sv_showCommands", "0");
	// setCvar("sv_showloss", "0");
	// setCvar("sv_timeout", "240");
	// setCvar("sv_wwwBaseURL", "");
	// setCvar("sv_wwwDlDisconnected", "0");
	// setCvar("sv_wwwDownload", "0");
	// setCvar("sv_zombietime", "2");
	setCvar("timescale", "1");
	// setCvar("ttycon", "1");
	// setCvar("ui_allow_bar", "1");
	// setCvar("ui_allow_bren", "1");
	// setCvar("ui_allow_enfield", "1");
	// setCvar("ui_allow_fg42", "0");
	// setCvar("ui_allow_kar98k", "1");
	// setCvar("ui_allow_kar98ksniper", "1");
	// setCvar("ui_allow_m1carbine", "1");
	// setCvar("ui_allow_m1garand", "1");
	// setCvar("ui_allow_mp40", "1");
	// setCvar("ui_allow_mp44", "1");
	// setCvar("ui_allow_nagant", "1");
	// setCvar("ui_allow_nagantsniper", "1");
	// setCvar("ui_allow_panzerfaust", "1");
	// setCvar("ui_allow_ppsh", "1");
	// setCvar("ui_allow_sniperrifles", "1");
	// setCvar("ui_allow_springfield", "1");
	// setCvar("ui_allow_sten", "1");
	// setCvar("ui_allow_thompson", "1");
	// setCvar("ui_allowVote", "1");
	// setCvar("ui_allowVoteClientKick", "0");
	// setCvar("ui_allowVoteDrawFriend", "0");
	// setCvar("ui_allowVoteFriendlyFire", "0");
	// setCvar("ui_allowVoteGameType", "1");
	// setCvar("ui_allowVoteKick", "0");
	// setCvar("ui_allowVoteKillCam", "0");
	// setCvar("ui_allowVoteMap", "1");
	// setCvar("ui_allowVoteMapRestart", "1");
	// setCvar("ui_allowVoteMapRotate", "1");
	// setCvar("ui_allowVoteTempBanClient", "0");
	// setCvar("ui_allowVoteTempBanUser", "0");
	// setCvar("ui_allowVoteTypeMap", "1");
	// setCvar("ui_drawfriend", "0");
	// setCvar("ui_friendlyfire", "0");
	// setCvar("ui_hostname", "CoDHost");
	// setCvar("ui_killcam", "1");
	// setCvar("ui_motd", "");
	// setCvar("ui_mousePitch", "0");
	// setCvar("ui_sd_roundlimit", "0");
	// setCvar("ui_sd_scorelimit", "10");
	// setCvar("ui_sd_timelimit", "0");
	// setCvar("ui_timeoutBank", "180000");
	// setCvar("ui_timeoutLength", "90000");
	// setCvar("ui_timeoutRecovery", "10000");
	// setCvar("ui_timeoutsAllowed", "0");
	// setCvar("username", "");
	// setCvar("version", "");
	// setCvar("viewlog", "1");
}
