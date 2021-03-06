static ConVar cvar;

void Setup_InsultToInjury()
{
    
    cvar = CreateChanceConVar("chaos_insult_injury", "0.50");
}

void Roll_InsultToInjury(int client)
{
    if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetRandomFloat(0.0, 1.0))
    {
        if (IsPlayerAlive(client))
        {
            SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamageInsultToInjury);
        }
    }
}

static Action OnTakeDamageInsultToInjury(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (victim < 1 || victim > MaxClients || attacker < 1 || attacker > MaxClients || victim == attacker)
	{
		SDKUnhook(victim, SDKHook_OnTakeDamage, OnTakeDamageInsultToInjury);
		return Plugin_Continue;
	}
	char name[32];
	GetEdictClassname(attacker, name, sizeof(name));
	if (!StrEqual(name, "trigger_hurt", false) || !StrEqual(name, "worldspawn", false) || GetClientTeam(attacker) == TEAM_SURVIVOR
	|| GetEntProp(attacker, Prop_Send, "m_zombieClass") != ZC_CHARGER)
	{
		SDKUnhook(victim, SDKHook_OnTakeDamage, OnTakeDamageInsultToInjury);
		return Plugin_Continue;
	}
	
	if ((GetEntProp(victim, Prop_Send, "m_iHealth") + GetEntPropFloat(victim, Prop_Send, "m_healthBuffer")) - damage > 0)
		return Plugin_Continue;
	
	for (int i = 1; i <= MaxClients; ++i)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == TEAM_SURVIVOR)
		{
			float origin[3], angle[3];
			GetEntPropVector(i, Prop_Send, "m_vecOrigin", origin);
			GetClientEyeAngles(i, angle);
			L4D2_SpawnSpecial(ZC_CHARGER, origin, angle);
		}
	}
	PrintHintTextToAll("Infected rolled: Insult to Injury!");
	SDKUnhook(victim, SDKHook_OnTakeDamage, OnTakeDamageInsultToInjury);
	return Plugin_Continue;
}