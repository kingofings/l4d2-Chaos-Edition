public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float velocity[3], float angles[3], int &weapon) 
{
	if(g_Cursed[client] == 1)
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
		
	if(g_Cursed[client] == 1)
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