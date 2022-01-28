static ConVar cvar;
static bool g_bSuppressiveFire[MAXPLAYERS + 1] = false;

void Setup_SuppressiveFire()
{
    cvar = CreateChanceConVar("chaos_suppressive_fire", "0.02");
}

void Roll_SuppressiveFire(int client, const char[] weapon)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))return;
	
	if (g_bSuppressiveFire[client])
	{
		int activeWep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if (!IsValidEntity(activeWep))return;
		
		int clip = GetEntProp(activeWep, Prop_Send, "m_iClip1");
		if(clip == 1) g_bSuppressiveFire[client] = false;
		
		return;
	}
	if(cvar.FloatValue == 1.0 || cvar.FloatValue > GetRandomFloat(0.0, 1.0))
	{
		if (!StrEqual(weapon, "rifle_m60"))return;
		g_bSuppressiveFire[client] = true;
		SDKHook(client, SDKHook_WeaponSwitch, WeaponSwitchSuppressiveFire);
		PrintHintText(client, "Suppressive fire!");
	}
}

static Action WeaponSwitchSuppressiveFire(int client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		if (g_bSuppressiveFire[client])return Plugin_Handled;
		else SDKUnhook(client, SDKHook_WeaponSwitch, WeaponSwitchSuppressiveFire);
	}
	PrintToServer("[CHAOS] Unhooked %N SuppressiveFire!", client);
	return Plugin_Continue;
}

bool IsSuppressiveFireActive(int client)
{
    if (g_bSuppressiveFire[client])return true;
    return false;
}

void Reset_SuppressiveFire(int client)
{
    g_bSuppressiveFire[client] = false;
}