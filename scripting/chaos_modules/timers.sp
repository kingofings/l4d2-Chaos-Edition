public Action Timer_HealthRoulette(Handle HRTimer, DataPack health_roulette)
{
	health_roulette.Reset();
	int client = GetClientFromSerial(health_roulette.ReadCell());
	float EngineTime = health_roulette.ReadFloat();
	if(CheckValidClient(client) && GetEngineTime() >= EngineTime && GetClientTeam(client) == 2)
	{
		int health = GetEntProp(client, Prop_Send, "m_iHealth");
		float buffer = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
		float totalHealth = buffer + float(health);
		int ibuffer = RoundToZero(buffer);
		int iTotalHealth = RoundToZero(totalHealth);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", buffer + 1.0); //need to add 1 to compensate for immediate health decay
		PrintHintText(client, "Permanent Health: %d. Temporary Health: %d. Total health: %d.", health, ibuffer, iTotalHealth);
		PrintToChat(client, "Permanent Health: %d. Temporary Health: %d. Total health: %d.", health, ibuffer, iTotalHealth);
		return Plugin_Stop;
	}
	else if(CheckValidClient(client))
	{
		int RNGRoll = GetRandomInt(1, 100);
		int RNGRollBuffer = GetRandomInt(1, 100);
		SetEntProp(client, Prop_Send, "m_iHealth", RNGRoll);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", float(RNGRollBuffer));
		SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
	}
	else
	{
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Timer_MetalMario(Handle PTimer, DataPack pack)
{
	pack.Reset();
	int client = GetClientFromSerial(pack.ReadCell());
	int RNGHealth = GetRandomInt(1, 50);
	float EngineTime = pack.ReadFloat();
	
	if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR && GetEngineTime() < EngineTime)
	{
		SetEntProp(client, Prop_Send, "m_iHealth", RNGHealth);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 50.0);
	}
	else if (CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		g_GodMode[client] = 0;
		SetEntProp(client, Prop_Send, "m_iHealth", 50);
		SetEntityRenderColor(client, 255, 255, 255, 255);
		PrintHintText(client, "Metal Mario Expired!");
		PrintToChat(client, "Metal Mario Expired!");
		return Plugin_Stop;
	}
	else
	{
		g_GodMode[client] = 0;
		PrintHintText(client, "Metal Mario Expired!");
		PrintToChat(client, "Metal Mario Expired!");
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action PlayPillLaugh(Handle LTimer, DataPack pack)
{
	pack.Reset();
	int client = GetClientFromSerial(pack.ReadCell());
	EmitSoundToAll("player/survivor/voice/manager/taunt07.wav", client);
}

public Action SetAWP(Handle SAWPTimer)
{
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 10000);
}

public Action ResetAWP(Handle RAWPTimer)
{
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 115);
}

public Action ResetAKJam(Handle AKTimer)
{
	char wak47[32] = "weapon_rifle_ak47";
	L4D2_SetFloatWeaponAttribute(wak47, L4D2FWA_CycleTime, 0.129999);
	for (int i = 1; i <= MaxClients; ++i)
	{
		if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) == 2)
		{
			PrintHintText(i, "Jammed AK-47 Expired! Shove to fire again!");
			PrintToChatAll("Jammed AK-47 Expired! Shove to fire again!");
		}
	}
}
//Starman gnome pickup roll replay theme if gnome is still held
public Action Timer_StarmanReapply(Handle StarRTimer, DataPack gnomeStar)
{
	gnomeStar.Reset();
	int timerArray[2];
	timerArray[0] = GetClientFromSerial(gnomeStar.ReadCell());
	timerArray[1] = EntRefToEntIndex(gnomeStar.ReadCell());
	int client = timerArray[0];
	int activeWeapon = timerArray[1];
	
	int currentActiveWeapon = GetEntProp(client, Prop_Send, "m_hActiveWeapon");
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && activeWeapon == currentActiveWeapon)
	{
		EmitSoundToAll("kingo_chaos_edition/gnome_starman.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/gnome_starman.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/gnome_starman.mp3", client, 103, SNDLEVEL_GUNFIRE, _, 1.0);
	}
	return Plugin_Continue;
}
//Gnome Starman Randomized Health/Stop timer
public Action Timer_GnomeStarman(Handle StarManTimer, DataPack gnomeStar)
{
	gnomeStar.Reset();
	int timerArray[2];
	timerArray[0] = GetClientFromSerial(gnomeStar.ReadCell());
	timerArray[1] = EntRefToEntIndex(gnomeStar.ReadCell());
	int client = timerArray[0];
	int activeWeapon = timerArray[1];
	int currentActiveWeapon = GetEntProp(client, Prop_Send, "m_hActiveWeapon");
	int RNGRed = GetRandomInt(1, 255);
	int RNGGreen = GetRandomInt(1, 255);
	int RNGBlue = GetRandomInt(1, 255);
	int RNGHealth = GetRandomInt(1, 50);
	if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR && activeWeapon == currentActiveWeapon)
	{
		SetEntProp(client, Prop_Send, "m_iHealth", RNGHealth);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 50.0);
		SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
		SetEntityRenderColor(client, RNGRed, RNGGreen, RNGBlue, 255);
	}
	else if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		g_GodMode[client] = 0;
		PrintHintText(client, "You dropped the gnome! Invincibility expired!");
		PrintToChat(client, "You dropped the gnome! Invincibility expired!");
		SetEntProp(client, Prop_Send, "m_iHealth", 100);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
		SetEntityRenderColor(client, 255, 255, 255, 255);
		StopSound(client, 100, "kingo_chaos_edition/gnome_starman.mp3");
		StopSound(client, 102, "kingo_chaos_edition/gnome_starman.mp3");
		StopSound(client, 103, "kingo_chaos_edition/gnome_starman.mp3");
		if(H_StarManReapply != INVALID_HANDLE)
		{
			KillTimer(H_StarManReapply);
			H_StarManReapply = INVALID_HANDLE;
		}
		
		return Plugin_Stop;
	}
	else
	{
		if(H_StarManReapply != INVALID_HANDLE)
		{
			KillTimer(H_StarManReapply);
			H_StarManReapply = INVALID_HANDLE;
		}
		return Plugin_Stop;
	}
	return Plugin_Continue;
}
//Cursed
public Action Timer_RemoveCursed(Handle HRemoveCurse, any clientid)
{
	int client = EntRefToEntIndex(clientid);
	g_Cursed[client] = 0;
}

//Carnival Ride
public Action Timer_ResetCarnivalRide(Handle HRestoreJResist, DataPack carnivalRide)
{
	carnivalRide.Reset();
	int attacker = GetClientFromSerial(carnivalRide.ReadCell());
	float EngineTime = carnivalRide.ReadFloat();
	if(!CheckValidClient(attacker))
	{
		L4D2_RestoreJockeyControlMax();
		L4D2_RestoreJockeyControlMin();
		L4D2_RestoreJockeyControlVar();
		PrintHintTextToAll("No Jockey Resistance expired, Jockey died!");
		PrintToChatAll("No Jockey Resistance expired, Jockey died!");
		StopSound(attacker, 100, "music/gallery_music.mp3");
		StopSound(attacker, 101, "music/gallery_music.mp3");
		StopSound(attacker, 102, "music/gallery_music.mp3");
		return Plugin_Stop;
	}
	else if(CheckValidClient(attacker) && GetEngineTime() >= EngineTime)
	{
		L4D2_RestoreJockeyControlMax();
		L4D2_RestoreJockeyControlMin();
		L4D2_RestoreJockeyControlVar();
		PrintHintTextToAll("No Jockey Resistance expired!");
		PrintToChatAll("No Jockey Resistance expired!");
		StopSound(attacker, 100, "music/gallery_music.mp3");
		StopSound(attacker, 101, "music/gallery_music.mp3");
		StopSound(attacker, 102, "music/gallery_music.mp3");
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Timer_ResetNoFall(Handle NFReset, any clientid)
{
	int client = EntRefToEntIndex(clientid);
	if(g_NoFall[client] == 1)
	{
		g_NoFall[client] = 0;
	}
}

public Action Timer_TankRockRoll(Handle timer, any rockid)
{
	int rock = EntRefToEntIndex(rockid);
	if(!IsValidEntity(rock))
	{
		PrintToServer("Rock Entity is not valid!");
		return Plugin_Stop;
	}

	int RNG = GetRandomInt(1, 2);
	if(RNG == 1)
	{
		SetEntityModel(rock, "models/props_vehicles/ambulance.mdl");
		EmitSoundToAll("kingo_chaos_edition/tank/rock_ambulance.mp3", rock, 100, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/tank/rock_ambulance.mp3", rock, 101, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/tank/rock_ambulance.mp3", rock, 102, SNDLEVEL_GUNFIRE, _, 1.0);
		return Plugin_Continue;
	}
	if(RNG == 2)
	{
		SetEntityModel(rock, "models/props_vehicles/cara_69sedan.mdl");
		return Plugin_Continue;
	}
	return Plugin_Continue;
}