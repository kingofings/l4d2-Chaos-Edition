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

public Action Command_Yeet(int client, int args)
{
	if(args < 1)
	{
		float velocity[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", velocity);
		velocity[0] += float(GetRandomInt(1, 800)); /* x coord */
		velocity[1] += float(GetRandomInt(1, 800)); /* y coord */
		velocity[2] += float(GetRandomInt(1, 800)); /* z coord */
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity);
		return Plugin_Handled;
	}
	else
	{
		char arg1[33];
	
		GetCmdArg(1, arg1, sizeof(arg1));
		int target = FindTarget(client, arg1);
		if(target <= COMMAND_TARGET_NONE)
		{
			ReplyToTargetError(client, target);
			return Plugin_Handled;
		}
	
		float velocity[3];
		GetEntPropVector(target, Prop_Data, "m_vecVelocity", velocity);
		velocity[0] += float(GetRandomInt(-800, 800)); /* x coord */
		velocity[1] += float(GetRandomInt(-800, 800)); /* y coord */
		velocity[2] += float(GetRandomInt(1, 800)); /* z coord */
		TeleportEntity(target, NULL_VECTOR, NULL_VECTOR, velocity);
		return Plugin_Handled;
	}
}

public Action Command_Incap(int client, int args)
{
	if(args < 1)
	{
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
		int health = GetEntProp(client, Prop_Send, "m_iHealth");
		SDKHooks_TakeDamage(client, client, client, float(health), _, _, _, _);
		return Plugin_Handled;
	}
	else
	{
		char arg1[33];
	
		GetCmdArg(1, arg1, sizeof(arg1));
		int target = FindTarget(client, arg1);
		if(target <= COMMAND_TARGET_NONE)
		{
			ReplyToTargetError(client, target);
			return Plugin_Handled;
		}
	
		SetEntPropFloat(target, Prop_Send, "m_healthBuffer", 0.0);
		int health = GetEntProp(target, Prop_Send, "m_iHealth");
		SDKHooks_TakeDamage(target, target, target, float(health), _, _, _, _);
		return Plugin_Handled;
	}
}