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
	{
		CreateTimer(1.4, Timer_TankRockRoll, EntIndexToEntRef(rock), TIMER_FLAG_NO_MAPCHANGE);
		g_TankRockCarEntity = rock;
	}
		
	return MRES_Ignored;
}

public MRESReturn OnTankRockTouchPost(int rock, Handle hParams)
{
	if(!IsValidEntity(g_TankRockCarEntity))
		return MRES_Ignored;

	if(!IsValidEntity(rock))
	{
		PrintToServer("Rock Touched something but Entity is invalid!");
		return MRES_Ignored;
	}
	if(rock == g_TankRockCarEntity)
	{
		int victim = DHookGetParam(hParams, 1);
		if(CheckValidClient(victim))
		{
			int tank = GetEntPropEnt(g_TankRockCarEntity, Prop_Send, "m_hOwnerEntity");
			SDKCall(g_sdkcallOnIncap, victim);
			Event eventincap = CreateEvent("player_incapacitated");
			if(eventincap && tank >= 1 && tank <= MaxClients && IsClientInGame(tank))
			{
				eventincap.SetInt("userid", GetClientUserId(victim));
				eventincap.SetInt("attacker", GetClientUserId(tank));
				for (int i = 1; i <= MaxClients; ++i)
				{
					if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
					eventincap.FireToClient(i);
				}
				delete eventincap;
			}
		}
	}
	
	if(rock == g_TankRockAmbulanceEntity)
	{
		StopSound(g_TankRockAmbulanceEntity, 100, "kingo_chaos_edition/tank/rock_ambulance.mp3");
		StopSound(g_TankRockAmbulanceEntity, 101, "kingo_chaos_edition/tank/rock_ambulance.mp3");
		StopSound(g_TankRockAmbulanceEntity, 102, "kingo_chaos_edition/tank/rock_ambulance.mp3");
		g_TankRockAmbulanceEntity = -1;
	}
	return MRES_Ignored;
}