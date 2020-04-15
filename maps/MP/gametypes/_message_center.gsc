messages()
//
// Originally from rudedog's message center for CoD Version 1.2.1
// 

{

	// Make sure the server runs even if message center is not set up.
if(getcvar("sv_message1") == "")
	setcvar("sv_message1", "*none*");
if(getcvar("sv_message2") == "")
	setcvar("sv_message2", "*none*");
if(getcvar("sv_message3") == "")
	setcvar("sv_message3", "*none*");
if(getcvar("sv_message4") == "")
	setcvar("sv_message4", "*none*");
if(getcvar("sv_message5") == "")
	setcvar("sv_message5", "*none*");
if(getcvar("sv_message6") == "")
	setcvar("sv_message6", "*none*");
if(getcvar("sv_message7") == "")
	setcvar("sv_message7", "*none*");
if(getcvar("sv_message8") == "")
	setcvar("sv_message8", "*none*");
if(getcvar("sv_message9") == "")
	setcvar("sv_message9", "*none*");


if(getcvar("sv_msgdelay") == "")
	setcvar("sv_msgdelay", "20"); //Delay between messages in seconds


	// print to screen
	print_text();

}

// print to screen
print_text()
{
	for (;;)
	{
		msg_delay = getcvarint("sv_msgdelay"); // set delay timer
		if (msg_delay < 2) setcvar("msg_delay", "6"); // check timer is over 2 seconds

		if (getcvar("sv_message1") != "*none*")
		{
			svmessage = getcvar("sv_message1"); // set message
			iprintln(svmessage); // print message 1
			wait msg_delay;
		}

		if (getcvar("sv_message2") != "*none*")
		{
			svmessage = getcvar("sv_message2"); // set message
			iprintln(svmessage); // print message 2
			wait msg_delay;
		}

		if (getcvar("sv_message3") != "*none*")
		{
			svmessage = getcvar("sv_message3"); // set message
			iprintln(svmessage); // print message 3
			wait msg_delay;
		}

		if (getcvar("sv_message4") != "*none*")
		{
			svmessage = getcvar("sv_message4"); // set message
			iprintln(svmessage); // print message 4
			wait msg_delay;
		}


		if (getcvar("sv_message5") != "*none*")
		{
			svmessage = getcvar("sv_message5"); // set message
			iprintln(svmessage); // print message 5
			wait msg_delay;
		}

		if (getcvar("sv_message6") != "*none*")
		{
			svmessage = getcvar("sv_message6"); // set message
			iprintln(svmessage); // print message 6
			wait msg_delay;
		}

		if (getcvar("sv_message7") != "*none*")
		{
			svmessage = getcvar("sv_message7"); // set message
			iprintln(svmessage); // print message 7
			wait msg_delay;
		}

		if (getcvar("sv_message8") != "*none*")
		{
			svmessage = getcvar("sv_message8"); // set message
			iprintln(svmessage); // print message 8
			wait msg_delay;
		}

		if (getcvar("sv_message9") != "*none*")
		{
			svmessage = getcvar("sv_message9"); // set message
			iprintln(svmessage); // print message 9
			wait msg_delay;
		}

	}
}
