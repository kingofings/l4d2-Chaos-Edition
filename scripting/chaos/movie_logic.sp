static ConVar cvar;
static float g_flTimeMovie[MAXPLAYERS + 1] = 0.0;
static bool g_bMovieActive[MAXPLAYERS + 1] = false;

void Setup_MovieLogic()
{
    cvar = CreateConVar("chaos_movie_logic", "0.01", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
}

void Roll_MovieLogic(int client, const char[] weapon)
{
	if(cvar.FloatValue == 1.0 || cvar.FloatValue > GetRandomFloat(0.0, 1.0))
	{
        if (GetClientTeam(client) == TEAM_SURVIVOR)
		{
			if (g_bMovieActive[client])return;
			g_bMovieActive[client] = true;
			
			if (!StrEqual(weapon, "pistol", false))return;
			
			int activeWep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if (!IsValidEntity(activeWep))return;
		
			if (!HasEntProp(activeWep, Prop_Send, "m_iClip1"))return;
			
			g_flTimeMovie[client] = GetGameTime() + 15.0;
			SDKHook(client, SDKHook_PreThink, MovieLogicPreThink);
			PrintHintText(client, "Movie logic!");
		}
	}
}

static Action MovieLogicPreThink(int client)
{
	if(IsClientInGame(client) && IsPlayerAlive(client))
	{
		if(!g_bMovieActive[client])
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			g_bMovieActive[client] = false;
			return Plugin_Continue;
		}
		int pistol = GetPlayerWeaponSlot(client, 1);
		if(!IsValidEntity(pistol))
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			g_bMovieActive[client] = false;
			return Plugin_Continue;
		}
		
		if(!HasEntProp(pistol, Prop_Send, "m_iClip1"))
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			g_bMovieActive[client] = false;
			return Plugin_Continue;
		}
		
		if(g_flTimeMovie[client] <= GetGameTime())
		{
			SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
			SetEntProp(pistol, Prop_Send, "m_iClip1", 0);
			g_bMovieActive[client] = false;
			return Plugin_Continue;
		}
		
		char name[32];
		GetEdictClassname(pistol, name, sizeof(name));
		if(!StrEqual(name, "weapon_pistol"))
			return Plugin_Continue;
	
		SetEntPropFloat(pistol, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() - 1.0);
		SetEntProp(pistol, Prop_Send, "m_iClip1", 230);
	}
	else if(IsClientInGame(client) && !IsPlayerAlive(client))
	{
		SDKUnhook(client, SDKHook_PreThink, MovieLogicPreThink);
		g_bMovieActive[client] = false;
	}	
	return Plugin_Continue;
}

void Reset_MovieLogic(int client)
{
    g_flTimeMovie[client] = 0.0;
    g_bMovieActive[client] = false;
}