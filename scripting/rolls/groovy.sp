Action Event_SpecialInfectedDeathPost(Event event, const char[] name, bool dontBroadcast)
{
	if(g_groovyChance.FloatValue == 1.0 || g_groovyChance.FloatValue > GetRandomFloat(0.0, 1.0))
	{
		char weapon[32];
		event.GetString("weapon", weapon, sizeof(weapon));
		if(!StrEqual(weapon, "chainsaw", false))
			return Plugin_Continue;
		
		int victim = GetClientOfUserId(event.GetInt("userid"));
		if(victim < 1 || victim > MaxClients || !IsClientInGame(victim))
			return Plugin_Continue;
		
		if(GetClientTeam(victim) != TEAM_INFECTED)
			return Plugin_Continue;
			
		int attacker = GetClientOfUserId(event.GetInt("attacker"));
		if(attacker < 1 || attacker > MaxClients || !IsClientInGame(attacker) || !IsPlayerAlive(attacker))
			return Plugin_Continue;
			
		/*if(GetEntProp(attacker, Prop_Send, "m_isIncapacitated") == 1)
			return Plugin_Continue;*/
			
		int chainsaw = GetPlayerWeaponSlot(attacker, 1);
		if(!IsValidEntity(chainsaw))
			return Plugin_Continue;
		
		int maxAmmo = c_maxChainsawAmmo.IntValue;
		int clip = GetEntProp(chainsaw, Prop_Send, "m_iClip1");
		int refill = GetRandomInt(10, maxAmmo);
		if(clip + refill > maxAmmo)
			SetEntProp(chainsaw, Prop_Send, "m_iClip1", maxAmmo);
		else
			SetEntProp(chainsaw, Prop_Send, "m_iClip1", clip + refill);
			
		PrintHintText(attacker, "You rolled: Groovy! Chainsaw fuel gained!");
	}
	return Plugin_Continue;
}