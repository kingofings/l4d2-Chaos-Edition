float g_timeMovie[MAXPLAYERS + 1] = 0.0;
bool g_movieActive[MAXPLAYERS + 1] = false;

Action Event_MovieLogic(Event event, const char[] name, bool dontBroadcast)
{
	float chance = GetRandomFloat(0.0, 1.0);
	if(g_movieLogicChance.FloatValue == 1.0 || g_movieLogicChance.FloatValue > chance)
	{
		int client = GetClientOfUserId(event.GetInt("userid"));
		if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == TEAM_SURVIVOR)
		{
			if(g_movieActive[client])
				return Plugin_Continue;
			g_movieActive[client] = true;
			char weapon[32];
			event.GetString("weapon", weapon, sizeof(weapon));
			PrintToServer("Weapon: %s", weapon);
			if(!StrEqual(weapon, "pistol", false))
				return Plugin_Continue;
			
			int activeWep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if(!IsValidEntity(activeWep))
				return Plugin_Continue;
		
			if(!HasEntProp(activeWep, Prop_Send, "m_iClip1"))
				return Plugin_Continue;
			g_timeMovie[client] = GetGameTime() + 15.0;
			SDKHook(client, SDKHook_PreThink, MovieLogicPreThink);
			PrintHintText(client, "You rolled: Movie logic!");
		}
	}
	return Plugin_Continue;
}

Action MovieLogicPreThink(int client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		if(!g_movieActive[client])
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			g_movieActive[client] = false;
			return Plugin_Continue;
		}
		int pistol = GetPlayerWeaponSlot(client, 1);
		if(!IsValidEntity(pistol))
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			g_movieActive[client] = false;
			return Plugin_Continue;
		}
		
		if(!HasEntProp(pistol, Prop_Send, "m_iClip1"))
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			g_movieActive[client] = false;
			return Plugin_Continue;
		}
		
		if(g_timeMovie[client] <= GetGameTime())
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			SetEntProp(pistol, Prop_Send, "m_iClip1", 0);
			g_movieActive[client] = false;
			return Plugin_Continue;
		}
		
		char name[32];
		GetEdictClassname(pistol, name, sizeof(name));
		if(!StrEqual(name, "weapon_pistol"))
			return Plugin_Continue;
	
		SetEntPropFloat(pistol, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() - 1.0);
		SetEntProp(pistol, Prop_Send, "m_iClip1", 230);
	}
	else if(client > 0 && client <= MaxClients && IsClientInGame(client) && !IsPlayerAlive(client))
	{
		SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
		g_movieActive[client] = false;
	}	
	return Plugin_Continue;
}