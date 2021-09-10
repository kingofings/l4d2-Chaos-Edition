public Action Event_RoundStart(Event event, const char[] sName, bool bDontBroadcast)
{
	char wak47[32] = "weapon_rifle_ak47";
	L4D2_SetFloatWeaponAttribute(wak47, L4D2FWA_CycleTime, 0.129999);
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 115);
	for(int client = 1; client <= MaxClients; ++client)
	{
		g_GnomePickedUp[client] = 0;
		g_Cursed[client] = 0;
		g_NoFall[client] = 0;
		g_GodMode[client] = 0;
		
	}
	g_randomCritActive = false;
	PrintToServer("[CHAOS] Reset Global Variables of all Players");	
}

public Action Event_RoundEnd(Event event, const char[] sName, bool bDontBroadcast)
{
	PrintToServer("Round End Fired!");
	char wak47[32] = "weapon_rifle_ak47";
	L4D2_SetFloatWeaponAttribute(wak47, L4D2FWA_CycleTime, 0.129999);
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 115);
	for(int client = 1; client <= MaxClients; ++client)
	{
		g_GnomePickedUp[client] = 0;
		g_Cursed[client] = 0;
		g_NoFall[client] = 0;
		g_GodMode[client] = 0;
	}
	g_randomCritActive = false;
	PrintToServer("[CHAOS] Reset Global Variables of all Players");
}

public Action Event_PillsUsed(Event event, const char[] sName, bool bDontBroadcast)
{
	int userid = event.GetInt("subject");
	int client = GetClientOfUserId(userid);
	int RNGRoll = GetRandomInt(1, 10);
	if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR && RNGRoll == 1)
	{
		g_GodMode[client] = 1;
		float EngineTime = GetEngineTime() + 10.0;
		DataPack pack;
		CreateDataTimer(0.1, Timer_MetalMario, pack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		pack.WriteCell(client);
		pack.WriteFloat(EngineTime);
		SetEntityRenderColor(client, 0, 0, 0, 255);
		PrintHintText(client, "You rolled: Metal Mario!");
		PrintToChat(client, "You rolled: Metal Mario!");
		//Play Multiple times and in different channels to make it louder
		EmitSoundToAll("kingo_chaos_edition/metal_mario.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/metal_mario.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/metal_mario.mp3", client, 103, SNDLEVEL_GUNFIRE, _, 1.0);
	}
	if(RNGRoll == 2 && CheckValidClient(client) && GetClientTeam(client) == 2)
	{
		float EngineTime = GetEngineTime() + 3.45;
		DataPack health_roulette;
		CreateDataTimer(0.1, Timer_HealthRoulette, health_roulette, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
		health_roulette.WriteCell(client);
		health_roulette.WriteFloat(EngineTime);
		PrintHintText(client, "You rolled: Health roulette!");
		PrintToChat(client, "You rolled: Health roulette");
		//Play Multiple times and in different channels to make it louder
		EmitSoundToAll("kingo_chaos_edition/health_roulette.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/health_roulette.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/health_roulette.mp3", client, 103, SNDLEVEL_GUNFIRE, _, 1.0);
		
	}
}

public Action Event_ReviveEnd(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	int victim = GetClientOfUserId(event.GetInt("subject"));
	int incapCount = GetEntProp(victim, Prop_Send, "m_currentReviveCount");
	int RNGRoll = GetRandomInt(1, 5);
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && RNGRoll == 1 && victim >= 1 && victim <= MaxClients && IsClientInGame(victim) && IsPlayerAlive(victim) && GetClientTeam(victim) == 2)
	{
		SetEntProp(client, Prop_Send, "m_isIncapacitated", 1);
		SetEntProp(victim, Prop_Send, "m_isIncapacitated", 0);
		SetEntProp(victim, Prop_Send, "m_iHealth", 1);
		SetEntPropFloat(victim, Prop_Send, "m_healthBuffer", 29.0);
		SetEntProp(victim, Prop_Send, "m_currentReviveCount", incapCount + 1);
		PrintHintText(client, "You rolled: Eye for an Eye!");
		PrintToChat(client,"You rolled: Eye for an Eye!"); //incase another message blocks the hint message
		PrintHintText(victim, "%N rolled Eye for an Eye! RISE!", client);
		PrintToChat(victim, "%N rolled Eye for an Eye! RISE!", client);
		if(incapCount == 1)
		{
			SetEntProp(victim , Prop_Send, "m_isGoingToDie", 1); //Vocalization of survivor voice responses
			SetEntProp(victim, Prop_Send, "m_bIsOnThirdStrike", 1); //Visual B&W effect for client
			for (int i = 1; i <= MaxClients; ++i)
			{
				if(i >= 1 && i <= MaxClients && IsClientInGame(i) && GetClientTeam(i) == 2 && !IsFakeClient(i)) //Only send hintbox to Survivors (and not bots) and not infected!!!
				{
					PrintHintText(i, "%N is Black and White!", victim);
				}
			}
		}
	}
}

public Action Event_WitchKilled(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	bool crowned = event.GetBool("oneshot");
	int RNG = GetRandomInt(1, 3);
	if(crowned)
	{
		if(RNG == 2)
		{
			float location[3];
			GetEntPropVector(client, Prop_Send, "m_vecOrigin", location);
			L4D2_SpawnTank(location, NULL_VECTOR);
			PrintHintText(client, "You rolled: Witch revenge!");
			PrintToChat(client, "You rolled: Witch revenge!");
			for (int i = 1; i <= MaxClients; ++i)
			{
				if(i >= 1 && i <= MaxClients && IsClientInGame(i) && GetClientTeam(i) == 2 && !IsFakeClient(i))
				{
					PrintHintText(i, "%N rolled: Witch revenge!", client);
				}
			}
		}	
	}
}

public Action Event_ItemPickup(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	char item[16];
	event.GetString("item", item, sizeof(item));
	int RNG = GetRandomInt(1, 4);
	if(StrEqual(item, "pain_pills") && CheckValidClient(client) && GetClientTeam(client) == 2 && RNG == 1)
	{
		int comFlags = GetCommandFlags("z_spawn_old"); 
		SetCommandFlags("z_spawn_old", comFlags & ~FCVAR_CHEAT); 
		FakeClientCommand(client, "z_spawn_old mob");
		EmitSoundToAll("player/survivor/voice/manager/spotpills01.wav", client);
		SetCommandFlags("z_spawn_old", comFlags|FCVAR_CHEAT);
		PrintHintText(client, "You rolled: Pills here!");
		PrintToChat(client, "You rolled: Pills here!");
		DataPack pack;
		CreateDataTimer(0.4, PlayPillLaugh, pack);
		pack.WriteCell(client);
	}
	if(StrEqual(item, "gnome", false) && CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR && g_GnomePickedUp[client] == 0)
	{
		g_GnomePickedUp[client] = 1;
		PrintToServer("[CHAOS] Client %N picked up the gnome for the first time", client);
		int RNGGnome = GetRandomInt(1, 25);
		
		if(RNGGnome == 1)
		{
			g_GodMode[client] = 1;
			int activeWeapon = GetEntProp(client, Prop_Send, "m_hActiveWeapon");
			int timerArray[2];
			timerArray[0] = client;
			timerArray[1] = activeWeapon;
			DataPack gnomeStar;
			CreateDataTimer(0.1, Timer_GnomeStarman, gnomeStar, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			gnomeStar.WriteCell(timerArray[0]);
			gnomeStar.WriteCell(timerArray[1]);
			PrintHintText(client, "You rolled: STARMAN INVINCIBLE UNTIL GNOME IS DROPPED DON'T GET PINNED!!!");
			PrintToChat(client, "You rolled: STARMAN INVINCIBLE UNTIL GNOME IS DROPPED DON'T GET PINNED!!!");
			H_StarManReapply = CreateTimer(12.4, Timer_StarmanReapply, gnomeStar, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			EmitSoundToAll("kingo_chaos_edition/gnome_starman.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/gnome_starman.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/gnome_starman.mp3", client, 103, SNDLEVEL_GUNFIRE, _, 1.0);
			for (int i = 1; i <= MaxClients; ++i)
			{
				if(i != client && i >= 1 && i <= MaxClients && IsClientInGame(i) && GetClientTeam(i) == 2)
				{
					PrintHintText(i, "%N ROLLED STARMAN PROTECT THEM FROM SPECIAL INFECTED!!!", client);
					PrintToChat(i, "%N ROLLED STARMAN PROTECT THEM FROM SPECIAL INFECTED!!!", client);
				}
				if(i != client && i >= 1 && i <= MaxClients && IsClientInGame(i) && GetClientTeam(i) == 3)
				{
					PrintHintText(i, "%N ROLLED STARMAN MAKE THEM DROP THE GNOME TO STOP THEM!!!", client);
					PrintToChat(i, "%N ROLLED STARMAN MAKE THEM DROP THE GNOME TO STOP THEM!!!", client);
				}
			}
		}
	}
}

public Action Event_AdrenalineUsed(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	int RNG = GetRandomInt(1, 6);
	
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && RNG == 1)
	{
		SetEntProp(client, Prop_Send, "m_isIncapacitated", 1);
		PrintHintText(client, "You rolled: Heart attack!");
		PrintToChat(client, "You rolled: Heart attack!");
	}
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && g_Cursed[client] == 0 && RNG == 2)
	{
		g_Cursed[client] = 1;
		CreateTimer(10.0, Timer_RemoveCursed, EntIndexToEntRef(client));
		PrintHintText(client, "You rolled: Cursed!");
		PrintToChat(client, "You rolled: Cursed!");
	}
	
	
}

public Action Event_DoorOpen(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	int RNG = GetRandomInt(1, 10);
	int RNGSDoor = GetRandomInt(1, 5);
	bool sDoor = event.GetBool("checkpoint");
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && RNG == 1 && !sDoor)
	{
		float location[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", location);
		int tank[4];
		tank[0] = L4D2_SpawnTank(location, NULL_VECTOR);
		tank[1] = L4D2_SpawnTank(location, NULL_VECTOR);
		tank[2] = L4D2_SpawnTank(location, NULL_VECTOR);
		tank[3] = L4D2_SpawnTank(location, NULL_VECTOR);
		PrintHintText(client, "You rolled: Jumpscare!");
		PrintToChat(client, "You rolled: Jumpscare!");
		SetEntProp(tank[0], Prop_Send, "m_iHealth", 1);
		SetEntProp(tank[1], Prop_Send, "m_iHealth", 1);
		SetEntProp(tank[2], Prop_Send, "m_iHealth", 1);
		SetEntProp(tank[3], Prop_Send, "m_iHealth", 1);
	}
	else if(CheckValidClient(client) && GetClientTeam(client) == 2 && RNGSDoor == 1 && sDoor)
	{
		float location[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", location);
		int tank[4];
		tank[0] = L4D2_SpawnTank(location, NULL_VECTOR);
		tank[1] = L4D2_SpawnTank(location, NULL_VECTOR);
		tank[2] = L4D2_SpawnTank(location, NULL_VECTOR);
		tank[3] = L4D2_SpawnTank(location, NULL_VECTOR);
		PrintHintText(client, "You rolled: Jumpscare!");
		PrintToChat(client, "You rolled: Jumpscare!");
		SetEntProp(tank[0], Prop_Send, "m_iHealth", 1);
		SetEntProp(tank[1], Prop_Send, "m_iHealth", 1);
		SetEntProp(tank[2], Prop_Send, "m_iHealth", 1);
		SetEntProp(tank[3], Prop_Send, "m_iHealth", 1);
	}
}

public Action Event_WeaponFire(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	char weapon[32];
	int RNG = GetRandomInt(1, 500);
	int RNGAWP = GetRandomInt(1, 50);
	//int RNGCrit = GetRandomInt(1, 50);
	event.GetString("weapon", weapon, sizeof(weapon));
	//ak jam
	if(StrEqual(weapon, "rifle_ak47") && RNG == 1 && CheckValidClient(client))
	{
		char ak47[32] = "weapon_rifle_ak47";
		L4D2_SetFloatWeaponAttribute(ak47, L4D2FWA_CycleTime, 20.0);
		CreateTimer(20.0, ResetAKJam);
		for (int i = 1; i <= MaxClients; ++i)
		{
			if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
			{
				PrintHintText(i, "Survivors rolled: Jammed AK-47 for 20 seconds!");
				PrintToChatAll("Survivors rolled: Jammed AK-47 for 20 seconds!");
			}
		}
	}
	if(StrEqual(weapon, "sniper_awp") && CheckValidClient(client) && RNGAWP == 1 && L4D2_GetIntWeaponAttribute("weapon_sniper_awp", L4D2IWA_Damage) != 10000)
	{
		CreateTimer(0.1, SetAWP);
		for (int i = 1; i <= MaxClients; ++i)
		{
			if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
			{
				PrintHintText(i, "Survivors rolled: CSGO AWP (1x 10000 DMG AWP bullet!)");
				PrintToChat(i, "Survivors rolled: CSGO AWP (1x 10000 DMG AWP bullet!)");
			}
		}	
	}
	if(StrEqual(weapon, "sniper_awp") && CheckValidClient(client) && L4D2_GetIntWeaponAttribute("weapon_sniper_awp", L4D2IWA_Damage) == 10000)
	{
		CreateTimer(0.1, ResetAWP);
		for (int i = 1; i <= MaxClients; ++i)
		{
			if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
			{
				PrintHintText(i, "10000 DMG AWP bullet used!");
				PrintToChat(i, "10000 DMG AWP bullet used!");
			}
		}
	}
	if(StrEqual(weapon, "pistol_magnum") && CheckValidClient(client))
	{
		int forceSwap = GetPlayerWeaponSlot(client, 0);
		int slot = GetPlayerWeaponSlot(client, 1);
		int RNGMagnum = GetRandomInt(1, 15);
		if(slot != -1 && forceSwap != -1 && CheckValidClient(client) && RNGMagnum == 1)
		{
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", forceSwap); //Need to do this if you dont swap before removing weapon the server segfaults!
			int wEntIndex = CreateEntityByName("weapon_pistol_magnum");
			int clip = GetEntProp(slot, Prop_Send, "m_iClip1");
			float location[3];
			GetEntPropVector(client, Prop_Send, "m_vecOrigin", location);
			location[2] += 80;
			TeleportEntity(wEntIndex, location, NULL_VECTOR, NULL_VECTOR);
			DispatchSpawn(wEntIndex);
			ActivateEntity(wEntIndex);
			PrintHintText(client, "You rolled: Noodle Hands!");
			PrintToChat(client, "You rolled: Noodle Hands!");
			if(clip - 1 != -1)
			{
				SetEntProp(wEntIndex, Prop_Send, "m_iClip1", clip - 1);
			}
			RemovePlayerItem(client, slot);
			AcceptEntityInput(slot, "Kill");
		}
	}
}

public Action Event_Incapped(Event event, const char[] sName, bool bDontBroadcast)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);
	int RNG = GetRandomInt(1, 100);
	if(client >= 1 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2 && RNG == 1)
	{
		SetEntProp(client, Prop_Send, "m_isIncapacitated", 0);
		SetEntProp(client, Prop_Send, "m_iHealth", 100);
		SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
		SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
		SetEntProp(client, Prop_Send, "m_bIsOnThirdStrike", 0);
		SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
		PrintHintText(client, "You rolled: Miracle! RISE FROM THE DEAD!");
		PrintToChat(client, "You rolled: Miracle! RISE FROM THE DEAD!");
	}
}

public Action Event_PlayerJump(Event event, const char[] sName, bool bDontBroadcast)
{
	int RNG = GetRandomInt(1, 500);
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(CheckValidClient(client) && GetClientTeam(client) == 2 && RNG == 1)
	{	
		g_NoFall[client] = 1;
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		ServerCommand("sm_slap \"#%N\" 0", client);
		PrintHintText(client, "You rolled: YEET!");
		PrintToChat(client, "You rolled: YEET!");
		EmitSoundToAll("kingo_chaos_edition/yeet.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/yeet.mp3", client, 101, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("kingo_chaos_edition/yeet.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
	}
}

//Unwanted visitor (Rescue spawn boomer)
public Action Event_SurvivorRescued(Event event, const char[] sName, bool bDontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("victim"));
	int RNG = GetRandomInt(1, 5);
	if(RNG == 1)
	{
		float location[3];
		GetEntPropVector(victim, Prop_Send, "m_vecOrigin", location);
		L4D2_SpawnSpecial(ZC_BOOMER, location, NULL_VECTOR);
	}
}
//Karma (Exploded boomer "explodes into bilejars")
public Action Event_BoomerExploded(Event event, const char[] sName, bool bDontBroadcast)
{
	int boomer = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	int RNG = GetRandomInt(1, 15);
	if(CheckValidClient(attacker) && RNG == 1)
	{
		int comFlags = GetCommandFlags("give"); 
		SetCommandFlags("give", comFlags & ~FCVAR_CHEAT); 
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		FakeClientCommand(boomer, "give weapon_vomitjar");
		SetCommandFlags("give", comFlags|FCVAR_CHEAT);
		PrintHintText(attacker, "You rolled: Karma!");
		PrintToChat(attacker, "You rolled: Karma!");
	}
}

public Action Event_PlayerSpawn(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	g_GnomePickedUp[client] = 0;
}
/*
public Action Event_TankSpawn(Event event, const char[] Name, bool bDontBroadcast)
{
	int tank = GetClientOfUserId(event.GetInt("userid"));
	SetEntityModel(tank, "models/survivors/survivor_manager.mdl");
}*/

public Action Event_BotPlayerReplace(Event event, const char[] Name, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("player"));
	if(g_GnomePickedUp[client] != 1)
	{
		g_GnomePickedUp[client] = 1;
		PrintToServer("Set %N gnome cookie back to gnome", client);
	}
}
//Carnival Ride
public Action Event_JockeyRide(Event event, const char[] Name, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt("userid"));	
	int RNG = GetRandomInt(1, 10);
	
	if(RNG == 1 && CheckValidClient(attacker))
	{
		float EngineTime = GetEngineTime() + 20.0;
		L4D2_SetJockeyControlMax(1.0);
		L4D2_SetJockeyControlMin(1.0);
		L4D2_SetJockeyControlVar(0.0);
		DataPack carnivalRide;
		CreateDataTimer(0.0 , Timer_ResetCarnivalRide, carnivalRide, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);	
		carnivalRide.WriteCell(attacker);
		carnivalRide.WriteFloat(EngineTime);
		PrintHintTextToAll("Infected rolled: No Jockey Resistance for 20 seconds!");
		PrintToChatAll("Infected rolled: No Jockey Resistance for 20 seconds!");
		EmitSoundToAll("music/gallery_music.mp3", attacker, 100, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("music/gallery_music.mp3", attacker, 101, SNDLEVEL_GUNFIRE, _, 1.0);
		EmitSoundToAll("music/gallery_music.mp3", attacker, 102, SNDLEVEL_GUNFIRE, _, 1.0);
	}
}
//Reset Fall damage immunity after player got yeeted
public Action Event_PlayerFallDamage(Event event, const char[] Name, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	CreateTimer(0.1, Timer_ResetNoFall, EntIndexToEntRef(client));
}