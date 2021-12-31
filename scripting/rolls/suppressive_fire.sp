bool g_suppressiveFire[MAXPLAYERS + 1] = false;

Action Event_SuppressiveFirePost(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client < 1 || client > MaxClients || !IsClientInGame(client) || !IsPlayerAlive(client))
		return Plugin_Continue;
	
	if(g_suppressiveFire[client])
	{
		int activeWep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if(!IsValidEntity(activeWep))
			return Plugin_Continue;
		
		int clip = GetEntProp(activeWep, Prop_Send, "m_iClip1");
		if(clip == 1)
			g_suppressiveFire[client] = false;
			
		return Plugin_Continue;
	}
	if(g_suppressiveFireChance.FloatValue == 1.0 || g_suppressiveFireChance.FloatValue > GetRandomFloat(0.0, 1.0))
	{
		char weapon[32];
		event.GetString("weapon", weapon, sizeof(weapon));
		if(!StrEqual(weapon, "rifle_m60"))
			return Plugin_Continue;
			
			
		/*if(GetEntProp(client, Prop_Send, "m_isIncapacitated") == 1)
			return Plugin_Continue;*/
			
		g_suppressiveFire[client] = true;
		SDKHook(client, SDKHook_WeaponSwitch, WeapoSwitchSuppressiveFire);
		PrintHintText(client, "You rolled: Suppressive fire!");
	}
	return Plugin_Continue;
}

void Event_SuppressiveFireEndPost(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		if(g_suppressiveFire[client])
			g_suppressiveFire[client] = false;	
	}
}

Action WeapoSwitchSuppressiveFire(int client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		if(g_suppressiveFire[client])
			return Plugin_Handled;
		else
			SDKUnhook(client, SDKHook_WeaponSwitch, WeapoSwitchSuppressiveFire);
	}
	PrintToServer("[CHAOS] Unhooked %N SuppressiveFire!", client);
	return Plugin_Continue;
}

