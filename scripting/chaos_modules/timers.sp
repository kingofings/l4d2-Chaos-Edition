public Action Timer_HealthRoulette(Handle HRTimer, DataPack health_roulette)
{
	health_roulette.Reset();
	int client = health_roulette.ReadCell();
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
	int client = pack.ReadCell();
	float EngineTime = pack.ReadFloat();
	
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && GetEngineTime() < EngineTime)
	{
		SetEntProp(client, Prop_Send, "m_iHealth", 10000);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 50.0);
	}
	else if (CheckValidClient(client) && GetClientTeam(client) == 2)
	{
		ServerCommand("sm_mortal \"#%N\"", client);
		SetEntProp(client, Prop_Send, "m_iHealth", 50);
		SetEntityRenderColor(client, 255, 255, 255, 255);
		PrintHintText(client, "Metal Mario Expired!");
		PrintToChat(client, "Metal Mario Expired!");
		return Plugin_Stop;
	}
	else
	{
		ServerCommand("sm_mortal \"#%N\"", client);
		PrintHintText(client, "Metal Mario Expired!");
		PrintToChat(client, "Metal Mario Expired!");
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action PlayPillLaugh(Handle LTimer, DataPack pack)
{
	pack.Reset();
	int client = pack.ReadCell();
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
	int client = gnomeStar.ReadCell();
	char SactiveWeapon[64];
	gnomeStar.ReadString(SactiveWeapon, sizeof(SactiveWeapon));
	int activeWeapon = StringToInt(SactiveWeapon);
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
	int client = gnomeStar.ReadCell();
	char SactiveWeapon[64];
	gnomeStar.ReadString(SactiveWeapon, sizeof(SactiveWeapon));
	int activeWeapon = StringToInt(SactiveWeapon);
	int currentActiveWeapon = GetEntProp(client, Prop_Send, "m_hActiveWeapon");
	int RNGRed = GetRandomInt(1, 255);
	int RNGGreen = GetRandomInt(1, 255);
	int RNGBlue = GetRandomInt(1, 255);
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && activeWeapon == currentActiveWeapon)
	{
		SetEntProp(client, Prop_Send, "m_iHealth", 10000);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 50.0);
		SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
		SetEntityRenderColor(client, RNGRed, RNGGreen, RNGBlue, 255);
	}
	else
	{
		ServerCommand("sm_mortal \"#%N\"", client);
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
	return Plugin_Continue;
}
//Set gnome cookie when rescuing survivor since it gets reset on player_spawn
public Action Timer_GnomeStarRescued(Handle RescuedGnomeStar, any clientid)
{
	int client = EntRefToEntIndex(clientid);
	char cookie[8];
	GetClientCookie(client, g_GnomePickUpCookie, cookie, sizeof(cookie));
	if(!StrEqual(cookie, "gnome", false))
	{
		SetClientCookie(client, g_GnomePickUpCookie, "gnome");
		PrintToServer("Set %N gnome cookie back to gnome", client);
	}
}

public Action Timer_ResetCrit(Handle HResetCrit)
{
	UnSetCritGrenade(400);
}
//Cursed
public Action Timer_RemoveCursed(Handle HRemoveCurse, any clientid)
{
	int client = EntRefToEntIndex(clientid);
	SetClientCookie(client, g_CursedCookie, "");
}

//Carnival Ride
public Action Timer_ResetCarnivalRide(Handle HRestoreJResist, DataPack carnivalRide)
{
	carnivalRide.Reset();
	int attacker = carnivalRide.ReadCell();
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