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

public MRESReturn OnTankRockReleasePost(int rock, Handle hParams)
{
	if(!IsValidEntity(rock))
	{
		PrintToServer("[CHAOS] Released Tank rock is invalid! Not trying to roll...");
		return MRES_Ignored;
	}
	
	int RNG = GetRandomInt(1, 5);
	PrintToServer("Tank rolled a %i", RNG);
	if(RNG == 1)
	{
		
		int RNGCar = GetRandomInt(1, 2);
		if(RNGCar == 1)
		{
			SetEntityModel(rock, "models/props_vehicles/ambulance.mdl");
			EmitSoundToAll("kingo_chaos_edition/tank/rock_ambulance.mp3", rock, 100, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/tank/rock_ambulance.mp3", rock, 101, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/tank/rock_ambulance.mp3", rock, 102, SNDLEVEL_GUNFIRE, _, 1.0);
			g_TankRockAmbulanceEntity = rock;
			g_TankRockCarEntity = rock;
			PrintToServer("[CHAOS] Thrower of car rock is %N", GetEntPropEnt(g_TankRockCarEntity, Prop_Send, "m_hThrower"));
			return MRES_Ignored;
		}
		if(RNGCar == 2)
		{
			g_TankRockCarEntity = rock;
			SetEntityModel(rock, "models/props_vehicles/cara_69sedan.mdl");
			return MRES_Ignored;
		}
	}	
	return MRES_Ignored;
}

public MRESReturn OnTankRockTouchPost(int rock, Handle hParams)
{
	if(!IsValidEntity(rock))
	{
		PrintToServer("[CHAOS] Rock Touched something but Entity is invalid!");
		return MRES_Ignored;
	}
	if(!IsValidEntity(g_TankRockCarEntity))
	{
		PrintToServer("[CHAOS] Rock is not a car ignoring!");
		return MRES_Ignored;
	}
	if(rock == g_TankRockCarEntity)
	{
		int victim = DHookGetParam(hParams, 1);
		if(CheckValidClient(victim) && GetClientTeam(victim) == TEAM_SURVIVOR)
		{
			int tank = GetEntPropEnt(g_TankRockCarEntity, Prop_Send, "m_hThrower");
			PrintToServer("[CHAOS] %N got hit by car rock! Incapping Player!", victim);
			ServerCommand("sm_incap \"#%N\"", victim);
			Event eventincap = CreateEvent("player_incapacitated");
			if(eventincap)
			{
				eventincap.SetInt("userid", GetClientUserId(victim));
				if(tank >= 1 && tank <= MaxClients && IsClientInGame(tank))
					eventincap.SetInt("attacker", GetClientUserId(tank));
				for (int i = 1; i <= MaxClients; ++i)
				{
					if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
						eventincap.FireToClient(i);
				}
				delete eventincap;
			}
		}
		g_TankRockCarEntity = -1;
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

/*public MRESReturn OnPipeBombDetonatedPost(int pipebomb, Handle hParams)
{
	if(!IsValidEntity(pipebomb))
		return MRES_Ignored;
		
	int owner = GetEntPropEnt(pipebomb, Prop_Send, "m_hOwnerEntity");
	if(owner >= 1 && owner <= MaxClients && IsClientInGame(owner) && g_demoManActive[owner])
	{
		PrintToServer("[CHAOS] Set Demoman of %N to false!", owner);
		g_demoManActive[owner] = false;
	}
	return MRES_Ignored;
}*/

public MRESReturn OnPipeBombSpawnPost(int pipebomb, Handle hParams)
{
	if(!IsValidEntity(pipebomb))
		return MRES_Ignored;
	
	int owner = GetEntPropEnt(pipebomb, Prop_Send, "m_hOwnerEntity");
	if(owner >= 1 && owner <= MaxClients && IsClientInGame(owner) && IsPlayerAlive(owner))
	{
		if(!g_demoManActive[owner])
		{
			float ChanceDemo = GetRandomFloat(0.0, 1.0);
			float ChanceThrow = GetRandomFloat(0.0, 1.0);
			PrintToServer("[CHAOS] Pipebomb thrown, Demolition man: %0.2f, Throwyourself: %0.2f", ChanceDemo, ChanceThrow);
			if(GetConVarFloat(c_demoManChance) > ChanceDemo || GetConVarFloat(c_demoManChance) == 1.0)
				SDKHook(pipebomb, SDKHook_Think, OnDemolitionMan);
				
			if(GetConVarFloat(c_throwYourSelfChance) > ChanceThrow || GetConVarFloat(c_throwYourSelfChance) == 1.0)
				SDKHook(pipebomb, SDKHook_Think, OnThrowYourself);
		}
	}
	return MRES_Ignored;
}