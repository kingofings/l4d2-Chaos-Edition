#include <sourcemod>
#include <sdktools>
#include <left4dhooks>
#include <clientprefs>
#include <chaos_modules/cvars.sp>
#include <chaos_modules/stocks.sp> 
#include <chaos_modules/events.sp>
#include <chaos_modules/timers.sp>

#pragma semicolon 1

public Plugin myinfo = 
{
	name = "[L4D2] Chaos Edition",
	author = "kingo",
	description = "Emulates the Chaos edition Mod from SM64",
	version = PLUGIN_VERSION,
	url = "http://steamcommunity.com/profiles/76561198084783019"
};
public void OnPluginStart()
{
	CreateConVars();
	HookEvent("pills_used", Event_PillsUsed);
	HookEvent("revive_end", Event_ReviveEnd);
	HookEvent("witch_killed", Event_WitchKilled);
	HookEvent("item_pickup", Event_ItemPickup);
	HookEvent("adrenaline_used", Event_AdrenalineUsed);
	HookEvent("door_open", Event_DoorOpen);
	HookEvent("weapon_fire", Event_WeaponFire);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("player_incapacitated", Event_Incapped);
	HookEvent("round_start", Event_RoundStart);
	HookEvent("player_jump", Event_PlayerJump);
	HookEvent("survivor_rescued", Event_SurvivorRescued);
	HookEvent("boomer_exploded", Event_BoomerExploded, EventHookMode_Pre);
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("bot_player_replace", Event_BotPlayerReplace);
	//HookEvent("tank_spawn", Event_TankSpawn);
}
public void OnPluginEnd()
{
	for(int client = 1; client <= MaxClients; ++client)
	{
		if(client >= 1 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && g_GnomePickUpCookie != null)
		{
			SetClientCookie(client, g_GnomePickUpCookie, "");
		}
	}
}



public void OnMapStart()
{
	PrecacheSound("kingo_chaos_edition/metal_mario.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/metal_mario.mp3");
	PrecacheSound("kingo_chaos_edition/health_roulette.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/health_roulette.mp3");
	PrecacheSound("kingo_chaos_edition/gnome_starman.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/gnome_starman.mp3");
	PrecacheSound("kingo_chaos_edition/yeet.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/yeet.mp3");
	
	char wak47[32] = "weapon_rifle_ak47";
	L4D2_SetFloatWeaponAttribute(wak47, L4D2FWA_CycleTime, 0.129999);
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 115);
	g_GnomePickUpCookie = RegClientCookie("gnome Cookie", "keeps track if player picked up the gnome before", CookieAccess_Private);
	for (int client = 1; client <= MaxClients; ++client)
	{
		SetClientCookie(client, g_GnomePickUpCookie, "");
	}
	
	
}
public void OnMapEnd()
{
	if(g_GnomePickUpCookie != INVALID_HANDLE)
	{
		CloseHandle(g_GnomePickUpCookie);
		g_GnomePickUpCookie = INVALID_HANDLE;
	}
	if(H_StarManReapply != INVALID_HANDLE)
	{
		CloseHandle(H_StarManReapply);
		H_StarManReapply = INVALID_HANDLE;
	}
}

public void OnClientConnected(int client)
{
	SetClientCookie(client, g_GnomePickUpCookie, "");
}