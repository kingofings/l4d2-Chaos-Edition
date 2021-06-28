public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float velocity[3], float angles[3], int &weapon) 
{
	char cookie[8];
	GetClientCookie(client, g_CursedCookie, cookie, sizeof(cookie));
	if(StrEqual(cookie, "cursed", false))
	{
		velocity[0] = -velocity[0];
		if(buttons & IN_FORWARD) 
		{
			buttons &= ~IN_FORWARD;
			buttons |= IN_BACK;	
		}
		else if(buttons & IN_BACK)
		{
			buttons &= ~IN_BACK;
			buttons |= IN_FORWARD;
		}
	}
		
	if(StrEqual(cookie, "cursed", false))
	{
		velocity[1] = -velocity[1];
		if(buttons & IN_MOVELEFT) 
		{
			buttons &= ~IN_MOVELEFT;
			buttons |= IN_MOVERIGHT;
		}	
		else if(buttons & IN_MOVERIGHT) 
		{
			buttons &= ~IN_MOVERIGHT;
			buttons |= IN_MOVELEFT;
		}
	}
}