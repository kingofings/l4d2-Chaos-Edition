public Action Event_RoundStart(Event event, const char[] sName, bool bDontBroadcast)
{
	char wak47[32] = "weapon_rifle_ak47";
	L4D2_SetFloatWeaponAttribute(wak47, L4D2FWA_CycleTime, 0.13);
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 115);
	for(int client = 1; client <= MaxClients; ++client)
	{
		g_GnomePickedUp[client] = false;
		g_Cursed[client] = false;
		g_NoFall[client] = false;
		g_GodMode[client] = false;
		
	}
	g_randomCritActive = false;
	PrintToServer("[CHAOS] Reset Global Variables of all Players");	
}

public Action Event_RoundEnd(Event event, const char[] sName, bool bDontBroadcast)
{
	PrintToServer("Round End Fired!");
	char wak47[32] = "weapon_rifle_ak47";
	L4D2_SetFloatWeaponAttribute(wak47, L4D2FWA_CycleTime, 0.13);
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 115);
	for(int client = 1; client <= MaxClients; ++client)
	{
		g_GnomePickedUp[client] = false;
		g_Cursed[client] = false;
		g_NoFall[client] = false;
		g_GodMode[client] = false;
	}
	g_randomCritActive = false;
	PrintToServer("[CHAOS] Reset Global Variables of all Players");
}

public Action Event_PillsUsed(Event event, const char[] sName, bool bDontBroadcast)
{
	int userid = event.GetInt("subject");
	int client = GetClientOfUserId(userid);
	float ChanceMetalMario = GetRandomFloat(0.0, 1.0);
	float ChanceHealthRoulette = GetRandomFloat(0.0, 1.0);
	if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		if(g_metalMarioChance.FloatValue > ChanceMetalMario || ChanceMetalMario == 1.0)
		{
			g_GodMode[client] = true;
			float EngineTime = GetEngineTime() + 10.0;
			DataPack pack;
			CreateDataTimer(0.1, Timer_MetalMario, pack, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			pack.WriteCell(GetClientSerial(client));
			pack.WriteFloat(EngineTime);
			SetEntityRenderColor(client, 0, 0, 0, 255);
			PrintHintText(client, "You rolled: Metal Mario!");
			PrintToChat(client, "You rolled: Metal Mario!");
			//Play Multiple times and in different channels to make it louder
			EmitSoundToAll("kingo_chaos_edition/metal_mario.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/metal_mario.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/metal_mario.mp3", client, 103, SNDLEVEL_GUNFIRE, _, 1.0);
		}
		if(g_HealthRouletteChance.FloatValue > ChanceHealthRoulette || ChanceHealthRoulette == 1.0)
		{
			float EngineTime = GetEngineTime() + 3.45;
			DataPack health_roulette;
			CreateDataTimer(0.1, Timer_HealthRoulette, health_roulette, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			health_roulette.WriteCell(GetClientSerial(client));
			health_roulette.WriteFloat(EngineTime);
			PrintHintText(client, "You rolled: Health roulette!");
			PrintToChat(client, "You rolled: Health roulette");
			//Play Multiple times and in different channels to make it louder
			EmitSoundToAll("kingo_chaos_edition/health_roulette.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/health_roulette.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/health_roulette.mp3", client, 103, SNDLEVEL_GUNFIRE, _, 1.0);
		}
	}
}

public Action Event_ReviveEnd(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	int victim = GetClientOfUserId(event.GetInt("subject"));
	int incapCount = GetEntProp(victim, Prop_Send, "m_currentReviveCount");
	float EyeForEyeChance = GetRandomFloat(0.0, 1.0);
	if(CheckValidClient(victim) && GetClientTeam(victim) == TEAM_SURVIVOR)
	{
		if(g_eyeForEyeChance.FloatValue > EyeForEyeChance || EyeForEyeChance == 1.0)
		{
			RequestFrame(ProcessIncapFrame, GetClientSerial(client));
			Event eventincap = CreateEvent("player_incapacitated");
			if(eventincap)
			{
				eventincap.SetInt("userid", GetClientUserId(client));
				eventincap.SetInt("attacker", GetClientUserId(victim));
				for (int i = 1; i <= MaxClients; ++i)
				{
					if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
						eventincap.FireToClient(i);
				}
				delete eventincap;
			}
		
			SDKCall(g_sdkcallOnRevive, victim);
			Event eventRevive = CreateEvent("revive_success");
			if(eventRevive)
			{
				eventRevive.SetInt("userid", GetClientUserId(victim));
				eventRevive.SetInt("attacker", GetClientUserId(client));
				for (int i = 1; i <= MaxClients; ++i)
				{
					if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
						eventRevive.FireToClient(i);
				}
				delete eventRevive;
			}
			PrintHintText(client, "You rolled: Eye for an Eye!");
			PrintToChat(client,"You rolled: Eye for an Eye!"); //incase another message blocks the hint message
			PrintHintText(victim, "%N rolled Eye for an Eye! RISE!", client);
			PrintToChat(victim, "%N rolled Eye for an Eye! RISE!", client);
		
			if(incapCount == 1)
			{
				for (int i = 1; i <= MaxClients; ++i)
				{
					if(i >= 1 && i <= MaxClients && IsClientInGame(i) && GetClientTeam(i) == 2 && !IsFakeClient(i)) //Only send hintbox to Survivors (and not bots) and not infected!!!
						PrintHintText(i, "%N is Black and White!", victim);
				}
			}
		}
	}
}

public Action Event_WitchKilled(Event event, const char[] sName, bool bDontBroadcast)
{
	bool crowned = event.GetBool("oneshot");
	if(crowned)
	{
		int client = GetClientOfUserId(event.GetInt("userid"));
		if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
		{
			float witchRevengeChance = GetRandomFloat(0.0, 1.0);
			if(g_witchRevengeChance.FloatValue > witchRevengeChance || witchRevengeChance == 1.0)
			{
				float location[3];
				GetEntPropVector(client, Prop_Send, "m_vecOrigin", location);
				L4D2_SpawnTank(location, NULL_VECTOR);
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
}

public Action Event_ItemPickup(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	char item[16];
	event.GetString("item", item, sizeof(item));
	if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		if(StrEqual(item, "pain_pills"))
		{
			float pillsHereChance = GetRandomFloat(0.0, 1.0);
			if(g_pillsHereChance.FloatValue > pillsHereChance || pillsHereChance == 1.0)
			{
				int comFlags = GetCommandFlags("z_spawn_old"); 
				SetCommandFlags("z_spawn_old", comFlags & ~FCVAR_CHEAT); 
				FakeClientCommand(client, "z_spawn_old mob");
				EmitSoundToAll("player/survivor/voice/manager/spotpills01.wav", client);
				SetCommandFlags("z_spawn_old", comFlags|FCVAR_CHEAT);
				PrintHintText(client, "You rolled: Pills here!");
				PrintToChat(client, "You rolled: Pills here!");
				DataPack pack;
				CreateDataTimer(0.4, PlayPillLaugh, pack, TIMER_FLAG_NO_MAPCHANGE);
				pack.WriteCell(GetClientSerial(client));
			}
		}
		if(StrEqual(item, "gnome", false) && !g_GnomePickedUp[client])
		{
			float starManChance = GetRandomFloat(0.0, 1.0);
			g_GnomePickedUp[client] = true;
			PrintToServer("[CHAOS] Client %N picked up the gnome for the first time", client);
		
			if(g_starManGnomeChance.FloatValue > starManChance || starManChance == 1.0)
			{
				g_GodMode[client] = true;
				int activeWeapon = GetEntProp(client, Prop_Send, "m_hActiveWeapon");
				int timerArray[2];
				timerArray[0] = GetClientSerial(client);
				timerArray[1] = EntIndexToEntRef(activeWeapon);
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
}

public Action Event_AdrenalineUsed(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	float heartAttackChance = GetRandomFloat(0.0, 1.0);
	float cursedChance = GetRandomFloat(0.0, 1.0);
	
	if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		if(g_heartAttackChance.FloatValue > heartAttackChance || heartAttackChance == 1.0)
		{
			RequestFrame(ProcessIncapFrame, GetClientSerial(client));
			PrintHintText(client, "You rolled: Heart attack!");
			PrintToChat(client, "You rolled: Heart attack!");
		}
		if(g_cursedChance.FloatValue > cursedChance || cursedChance == 1.0)
		{
			if(!g_Cursed[client])
			{
				g_Cursed[client] = true;
				CreateTimer(10.0, Timer_RemoveCursed, EntIndexToEntRef(client), TIMER_FLAG_NO_MAPCHANGE);
				PrintHintText(client, "You rolled: Cursed!");
				PrintToChat(client, "You rolled: Cursed!");
			}
		}
	}
}

public Action Event_DoorOpen(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	bool sDoor = event.GetBool("checkpoint");
	if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		float chance = GetRandomFloat(0.0, 1.0);
		if(!sDoor)
		{
			if(g_jumpScareChance.FloatValue > chance || chance == 1.0)
			{
				float location[3];
				GetEntPropVector(client, Prop_Send, "m_vecOrigin", location);
				int tank[4];
				for(int i = 0; i <= sizeof(tank) -1; i++)
				{
					tank[i] = L4D2_SpawnTank(location, NULL_VECTOR);
					SetEntProp(tank[i], Prop_Send, "m_iHealth", 1);
				}
				PrintHintText(client, "You rolled: Jumpscare!");
				PrintToChat(client, "You rolled: Jumpscare!");
			}
		}
		else
		{
			if(g_jumpScareSChance.FloatValue > chance || chance == 1.0)
			{
				float location[3];
				GetEntPropVector(client, Prop_Send, "m_vecOrigin", location);
				int tank[4];
				for(int i = 0; i <= sizeof(tank) -1; i++)
				{
					tank[i] = L4D2_SpawnTank(location, NULL_VECTOR);
					SetEntProp(tank[i], Prop_Send, "m_iHealth", 1);
				}
				PrintHintText(client, "You rolled: Jumpscare!");
				PrintToChat(client, "You rolled: Jumpscare!");
			}
		}
	}
}

public Action Event_WeaponFire(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	char weapon[32];
	event.GetString("weapon", weapon, sizeof(weapon));
	//ak jam
	if(StrEqual(weapon, "rifle_ak47") && CheckValidClient(client))
	{
		float chance = GetRandomFloat(0.0, 1.0);
		if(g_akJamChance.FloatValue > chance || chance == 1.0)
		{
			char ak47[32] = "weapon_rifle_ak47";
			L4D2_SetFloatWeaponAttribute(ak47, L4D2FWA_CycleTime, 20.0);
			CreateTimer(20.0, ResetAKJam, _, TIMER_FLAG_NO_MAPCHANGE);
			for (int i = 1; i <= MaxClients; ++i)
			{
				if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
				{
					PrintHintText(i, "Survivors rolled: Jammed AK-47 for 20 seconds!");
					PrintToChatAll("Survivors rolled: Jammed AK-47 for 20 seconds!");
				}
			}
		}
	}
	if(StrEqual(weapon, "sniper_awp") && CheckValidClient(client) && L4D2_GetIntWeaponAttribute("weapon_sniper_awp", L4D2IWA_Damage) != 10000)
	{
		float chance = GetRandomFloat(0.0, 1.0);
		if(g_csgoAWPChance.FloatValue > chance || chance == 1.0)
		{
			CreateTimer(0.1, SetAWP, _, TIMER_FLAG_NO_MAPCHANGE);
			for (int i = 1; i <= MaxClients; ++i)
			{
				if(i >= 1 && i <= MaxClients && IsClientInGame(i) && !IsFakeClient(i))
				{
					PrintHintText(i, "Survivors rolled: CSGO AWP (1x 10000 DMG AWP bullet!)");
					PrintToChat(i, "Survivors rolled: CSGO AWP (1x 10000 DMG AWP bullet!)");
				}
			}
		}
	}
	if(StrEqual(weapon, "sniper_awp") && CheckValidClient(client) && L4D2_GetIntWeaponAttribute("weapon_sniper_awp", L4D2IWA_Damage) == 10000)
	{
		CreateTimer(0.1, ResetAWP, _, TIMER_FLAG_NO_MAPCHANGE);
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
		if(slot != -1 && forceSwap != -1 && CheckValidClient(client))
		{
			float chance = GetRandomFloat(0.0, 1.0);
			if(g_noodleArms.FloatValue > chance || chance == 1.0)
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
}

public Action Event_Incapped(Event event, const char[] sName, bool bDontBroadcast)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);
	if(client >= 1 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		float chance = GetRandomFloat(0.0, 1.0);
		if(g_miracleChance.FloatValue > chance || chance == 1.0)
		{
			SDKCall(g_sdkcallOnRevive, client);
			SetEntProp(client, Prop_Send, "m_iHealth", 100);
			SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
			SetEntProp(client, Prop_Send, "m_isGoingToDie", 0);
			SetEntProp(client, Prop_Send, "m_bIsOnThirdStrike", 0);
			SetEntProp(client, Prop_Send, "m_currentReviveCount", 0);
			PrintHintText(client, "You rolled: Miracle! RISE FROM THE DEAD!");
			PrintToChat(client, "You rolled: Miracle! RISE FROM THE DEAD!");
		}
	}
}

public Action Event_PlayerJump(Event event, const char[] sName, bool bDontBroadcast)
{
	float ChanceYeet = GetRandomFloat(0.0, 1.0);
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(GetConVarFloat(c_yeetChance) > ChanceYeet || ChanceYeet == 1.0)
	{
		if(CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
		{
			g_NoFall[client] = true;
			RequestFrame(ProcessYeet, GetClientSerial(client));
			SDKHook(client, SDKHook_PreThink, OnPreThinkYeet);
			PrintToServer("[CHAOS] Gave %N fall damage immunity!", client);
			PrintHintText(client, "You rolled: YEET!");
			PrintToChat(client, "You rolled: YEET!");
			EmitSoundToAll("kingo_chaos_edition/yeet.mp3", client, 100, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/yeet.mp3", client, 101, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("kingo_chaos_edition/yeet.mp3", client, 102, SNDLEVEL_GUNFIRE, _, 1.0);
		}
	}
}

//Unwanted visitor (Rescue spawn boomer)
public Action Event_SurvivorRescued(Event event, const char[] sName, bool bDontBroadcast)
{
	int victim = GetClientOfUserId(event.GetInt("victim"));
	float chance = GetRandomFloat(0.0, 1.0);
	if(g_unwantedVisitorChance.FloatValue > chance || chance == 1.0)
	{
		if(CheckValidClient(victim))
		{
			float location[3];
			GetEntPropVector(victim, Prop_Send, "m_vecOrigin", location);
			L4D2_SpawnSpecial(ZC_BOOMER, location, NULL_VECTOR);
		}
	}
}
//Karma (Exploded boomer "explodes into bilejars")
public Action Event_BoomerExploded(Event event, const char[] sName, bool bDontBroadcast)
{
	float chance = GetRandomFloat(0.0, 1.0);
	if(g_karmaChance.FloatValue > chance || chance == 1.0)
	{
		int boomer = GetClientOfUserId(event.GetInt("userid"));
		int attacker = GetClientOfUserId(event.GetInt("attacker"));
		if(CheckValidClient(attacker) && IsClientInGame(boomer) && boomer >= 1 && boomer <= MaxClients)
		{
			float location[3];
			GetEntPropVector(boomer, Prop_Send, "m_vecOrigin", location);
			location[2] += 80;
			for(int i = 0 ; i < 12; i++)
			{
				int entity = CreateEntityByName("weapon_vomitjar");
				if(IsValidEntity(entity))
				{
					TeleportEntity(entity, location, NULL_VECTOR, NULL_VECTOR);
					DispatchSpawn(entity);
					ActivateEntity(entity);
					RequestFrame(OnKarmaLaunchVomitJar, EntIndexToEntRef(entity));
				}
			}
			PrintHintText(attacker, "You rolled: Karma!");
			PrintToChat(attacker, "You rolled: Karma!");
		}
	}
}

public Action Event_PlayerSpawn(Event event, const char[] sName, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	g_GnomePickedUp[client] = false;
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
	if(!g_GnomePickedUp[client])
	{
		g_GnomePickedUp[client] = true;
		PrintToServer("Set %N gnome cookie back to gnome", client);
	}
}
//Carnival Ride
public Action Event_JockeyRide(Event event, const char[] Name, bool bDontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt("userid"));	
	float chance = GetRandomFloat(0.0, 1.0);
	
	if(g_noJockeyResistanceChance.FloatValue > chance || chance == 1.0)
	{
		if(CheckValidClient(attacker))
		{
			float EngineTime = GetEngineTime() + 20.0;
			L4D2_SetJockeyControlMax(1.0);
			L4D2_SetJockeyControlMin(1.0);
			L4D2_SetJockeyControlVar(0.0);
			DataPack carnivalRide;
			CreateDataTimer(0.0 , Timer_ResetCarnivalRide, carnivalRide, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);	
			carnivalRide.WriteCell(GetClientSerial(attacker));
			carnivalRide.WriteFloat(EngineTime);
			PrintHintTextToAll("Infected rolled: No Jockey Resistance for 20 seconds!");
			PrintToChatAll("Infected rolled: No Jockey Resistance for 20 seconds!");
			EmitSoundToAll("music/gallery_music.mp3", attacker, 100, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("music/gallery_music.mp3", attacker, 101, SNDLEVEL_GUNFIRE, _, 1.0);
			EmitSoundToAll("music/gallery_music.mp3", attacker, 102, SNDLEVEL_GUNFIRE, _, 1.0);
		}
	}
}
//Reset Fall damage immunity after player got yeeted
/*
public Action Event_PlayerFallDamage(Event event, const char[] Name, bool bDontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	CreateTimer(0.1, Timer_ResetNoFall, EntIndexToEntRef(client), TIMER_FLAG_NO_MAPCHANGE);
}
*/