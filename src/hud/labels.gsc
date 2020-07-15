create(tl, tr, bl, br)
{
	destroy_();

	if (isDefined(tl)) {
		level._hud_label_tl = newHudElem();
		level._hud_label_tl.x = 10;
		level._hud_label_tl.y = 10;
		level._hud_label_tl.alignX = "left";
		level._hud_label_tl.alignY = "top";
		level._hud_label_tl.fontScale = 1;
		level._hud_label_tl.color = (1, 1, 1);
		level._hud_label_tl setText(tl);
	}
	if (isDefined(tr)) {
		level._hud_label_tr = newHudElem();
		level._hud_label_tr.x = 640 - 10;
		level._hud_label_tr.y = 10;
		level._hud_label_tr.alignX = "right";
		level._hud_label_tr.alignY = "top";
		level._hud_label_tr.fontScale = 1;
		level._hud_label_tr.color = (1, 1, 1);
		level._hud_label_tr setText(tr);
	}
	if (isDefined(bl)) {
		level._hud_label_bl           = newHudElem();
		level._hud_label_bl.x         = 630;
		level._hud_label_bl.y         = 475;
		level._hud_label_bl.alignX    = "right";
		level._hud_label_bl.alignY    = "middle";
		level._hud_label_bl.sort      = -3;
		level._hud_label_bl.fontScale = 0.7;
		level._hud_label_bl.archived  = false;
		level._hud_label_bl setText(bl);
	}
	if (isDefined(br)) {
		level._hud_label_br = newHudElem();
		level._hud_label_br.x = 3;
		level._hud_label_br.alignX = "left";
		level._hud_label_br.y = 475;
		level._hud_label_br.alignY = "middle";
		level._hud_label_br.sort = -3;
		level._hud_label_br.fontScale = 0.7;
		level._hud_label_br.archived = false;
		level._hud_label_br setText(br);
	}
}

destroy_()
{
	if (isDefined(level._hud_label_tl)) {
		level._hud_label_tl destroy();
	}
	if (isDefined(level._hud_label_tr)) {
		level._hud_label_tr destroy();
	}
	if (isDefined(level._hud_label_bl)) {
		level._hud_label_bl destroy();
	}
	if (isDefined(level._hud_label_br)) {
		level._hud_label_br destroy();
	}
}
