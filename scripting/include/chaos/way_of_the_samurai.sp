//needs full rewrite

bool g_samuraiActive[MAXPLAYERS + 1] = false;
bool g_hasKatana[MAXPLAYERS + 1] = false;
float g_samuraiTime[MAXPLAYERS + 1] = 0.0;

Action Event_WayOfTheSamuraiPost(Event event, const char[] name, bool dontBroadCast)
{
	int health = event.GetInt("health");
	if(health > 20)
		return Plugin_Continue;
		
	int victim = GetClientOfUserId(event.GetInt("userid"));
	if(victim < 1 || victim > MaxClients || !IsClientInGame(victim) || !IsPlayerAlive(victim))
	{
		if(GetClientTeam(victim) != TEAM_SURVIVOR)
			return Plugin_Continue;		
	}
	
	if(g_samuraiActive[victim])
		return Plugin_Continue;
	
	int weapon = GetPlayerWeaponSlot(victim, 1);
	if(!IsValidEntity(weapon))
		return Plugin_Continue;
	
	char katana[32];
	GetEdictClassname(weapon, katana, sizeof(katana));
	PrintToServer("Player weapon: %s", katana);
	if(!StrEqual(katana, "weapon_melee", false))
		return Plugin_Continue;
	
	if(g_wayOfSamuraiChance.FloatValue == 1.0 || g_wayOfSamuraiChance.FloatValue > GetRandomFloat(0.0, 1.0))
	{
		int attacker = GetClientOfUserId(event.GetInt("userid"));
		if(attacker < 1 || attacker > MaxClients || !IsClientInGame(attacker))
		{
			if(GetClientTeam(attacker) != TEAM_INFECTED)
				return Plugin_Continue;
		}
		g_samuraiActive[victim] = true;
		g_samuraiTime[victim] = GetGameTime() + 7.0;
		SDKHook(victim, SDKHook_PreThink, OnSamuraiPreThink);
		SetEntPropEnt(victim, Prop_Send, "m_hActiveWeapon", weapon);
		SDKHook(victim, SDKHook_WeaponSwitch, OnWeaponSwitchSamurai);
		PrintHintText(victim, "You rolled: Way of the samurai!");
	}
	return Plugin_Continue;
}

Action Event_WayOfTheSamuraiCheckKatanaPickUpPost(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		char item[32];
		event.GetString("item", item, sizeof(item));
		PrintToServer("Item: %s", item);
	}
}

Action Event_WayOfTheSamuraiCheckKatanaDropPost(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		char item[32];
		event.GetString("item", item, sizeof(item));
		PrintToServer("Item: %s", item);
	}
}
Action OnSamuraiPreThink(int client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client))
	{
		if(g_samuraiTime[client] <= GetGameTime())
		{
			g_samuraiActive[client] = false;
			SDKUnhook(client, SDKHook_PreThink, OnSamuraiPreThink);
			return Plugin_Continue;
		}
		if(!IsPlayerAlive(client))
		{
			g_samuraiActive[client] = false;
			SDKUnhook(client, SDKHook_PreThink, OnSamuraiPreThink);
			return Plugin_Continue;
		}	
		int activeWep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if(!IsValidEntity(activeWep))
			return Plugin_Continue;
			
		char katana[32];
		GetEdictClassname(activeWep, katana, sizeof(katana));
		PrintToServer("Player weapon: %s", katana);
		if(!StrEqual(katana, "weapon_melee", false))
			return Plugin_Continue;
			
		SetEntPropFloat(activeWep, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() - 1.0);
	}
	return Plugin_Continue; 
}



Action OnWeaponSwitchSamurai(int client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		if(g_samuraiActive[client])
			return Plugin_Handled;
		else
			SDKUnhook(client, SDKHook_WeaponSwitch, OnWeaponSwitchSamurai);
	}
	return Plugin_Continue;
}