public MRESReturn OnGrenadeLauncherProjSpawnPre(int projectile, Handle hParams)
{
	if(!IsValidEntity(projectile))
		return MRES_Ignored;
	
	int RNGCrit = GetRandomInt(1, 50);
	int client = GetEntPropEnt(projectile, Prop_Send, "m_hOwnerEntity");
	if(RNGCrit == 1 && !g_randomCritActive)
	{
		g_randomCritActive = true;
		SetCritGrenade(3);
		PrintHintText(client, "You rolled: Random Crit!");
		PrintToChat(client, "You rolled: Random Crit!");
		EmitSoundToAll("kingo_chaos_edition/crit_grenade_launcher.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/crit_grenade_launcher.mp3", client, 101, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/crit_grenade_launcher.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
	}
	return MRES_Ignored;
}

public MRESReturn OnGrenadeLauncherProjExplodePost(int projectile, Handle hParams)
{
	if(g_randomCritActive)
	{
		UnSetCritGrenade();
		g_randomCritActive = false;
	}
	return MRES_Ignored;
}

public MRESReturn OnTankRockSpawnPost(int rock, Handle hParams)
{
	if(!IsValidEntity(rock))
		return MRES_Ignored;
	
	int RNG = GetRandomInt(1, 5);
	if(RNG == 1)
		CreateTimer(1.4, Timer_TankRockRoll, EntIndexToEntRef(rock), TIMER_FLAG_NO_MAPCHANGE);
	return MRES_Ignored;
}