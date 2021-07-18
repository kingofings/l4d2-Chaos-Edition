public Action OnTakeDamage(int client, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if(g_NoFall[client] == 1 && CheckValidClient(client) && damagetype & DMG_FALL && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		return Plugin_Handled;
	}
	if(g_GodMode[client] == 1 && CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}