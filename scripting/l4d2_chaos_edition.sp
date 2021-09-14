#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <left4dhooks>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required
#include <chaos_modules/cvars.sp>
#include <chaos_modules/stocks.sp> 
#include <chaos_modules/events.sp>
#include <chaos_modules/timers.sp>
#include <chaos_modules/commands.sp>
#include <chaos_modules/sdkhooks.sp>
#include <chaos_modules/dhooks.sp>



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
	RegAdminCmd("sm_yeet", Command_Yeet, ADMFLAG_CHEATS);
	RegAdminCmd("sm_incap", Command_Incap, ADMFLAG_CHEATS);
	RegAdminCmd("sm_explode", Command_Explode, ADMFLAG_CHEATS);
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
	HookEvent("jockey_ride", Event_JockeyRide);
	HookEvent("player_falldamage", Event_PlayerFallDamage);
	for (int i = 1; i <= MaxClients; ++i)
	{
		if(IsClientInGame(i))
		{
			SDKHook(i, SDKHook_OnTakeDamage, OnTakeDamage);
		}
	}
	
	Handle hGameConf = new GameData("l4d2.chaos");
	if(!hGameConf)
		SetFailState("Could not find chaos gamedata!");
		
	Handle dtGrenadeProjExplode = DHookCreateFromConf(hGameConf, "CGrenadeLauncher_Projectile::ExplodeTouch()");
	if(!dtGrenadeProjExplode)
		SetFailState("Failed to create detour %s", "CGrenadeLauncher_Projectile::ExplodeTouch()");
	DHookEnableDetour(dtGrenadeProjExplode, true, OnGrenadeLauncherProjExplodePost);
	
	Handle dtGrenadeProjSpawned = DHookCreateFromConf(hGameConf, "CGrenadeLauncher_Projectile::Spawn()");
	if(!dtGrenadeProjSpawned)
		SetFailState("Failed to create detour %s", "CGrenadeLauncher_Projectile::Spawn()");	
	DHookEnableDetour(dtGrenadeProjSpawned, false, OnGrenadeLauncherProjSpawnPre);
	
	Handle dtOnTankRockRelease = DHookCreateFromConf(hGameConf, "CTankRock::OnRelease()");
	if(!dtOnTankRockRelease)
		SetFailState("Failed to create detour %s", "CTankRock::OnRelease()");
	DHookEnableDetour(dtOnTankRockRelease, true, OnTankRockReleasePost);
	
	Handle dtOnTankRockTouch = DHookCreateFromConf(hGameConf, "CTankRock::BounceTouch()");
	if(!dtOnTankRockTouch)
		SetFailState("Failed to create detour %s", "CTankRock::BounceTouch()");
	DHookEnableDetour(dtOnTankRockTouch, true, OnTankRockTouchPost);
	
	Handle dtOnPipeBombDetonate = DHookCreateFromConf(hGameConf, "CPipeBombProjectile::Detonate()");
	if(!dtOnPipeBombDetonate)
		SetFailState("Failed to create detour %s", "CPipeBombProjectile::Detonate()");
	DHookEnableDetour(dtOnPipeBombDetonate, true, OnPipeBombDetonatedPost);
	
	//Revive SDKCall
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hGameConf, SDKConf_Signature, "CTerrorPlayer::OnRevived()");
	g_sdkcallOnRevive = EndPrepSDKCall();
	if(!g_sdkcallOnRevive)
		SetFailState("Failed to Prepare SDKCall %s signature broken?", "CTerrorPlayer::OnRevived()");
	
	//Explode Pipebombs
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hGameConf, SDKConf_Signature, "CPipeBombProjectile::Detonate()");
	g_sdkcallExplodePipeBomb = EndPrepSDKCall();
	if(!g_sdkcallExplodePipeBomb)
		SetFailState("Failed to Prepare SDKCall %s signature broken?", "CPipeBombProjectile::Detonate()");
		
	delete hGameConf;
		
}

public void OnMapStart()
{
	//Precache
	
	//Sound Precache
	
	PrecacheSound("kingo_chaos_edition/metal_mario.mp3");
	PrecacheSound("kingo_chaos_edition/health_roulette.mp3");
	PrecacheSound("kingo_chaos_edition/gnome_starman.mp3");
	PrecacheSound("kingo_chaos_edition/yeet.mp3");
	PrecacheSound("kingo_chaos_edition/crit_grenade_launcher.mp3");
	PrecacheSound("music/gallery_music.mp3");
	PrecacheSound("kingo_chaos_edition/tank/rock_ambulance.mp3");
	PrecacheSound("kingo_chaos_edition/demoman/kaboom.mp3");
	
	//Model Precache
	
	PrecacheModel("models/props_vehicles/cara_69sedan.mdl", true);
	PrecacheModel("models/props_vehicles/ambulance.mdl", true);
	
	//Particles
	
	PrecacheParticle(PARTICLE_FUSE);
	PrecacheParticle(PARTICLE_LIGHT);
	
	//Download Table
	
	AddFileToDownloadsTable("sound/kingo_chaos_edition/metal_mario.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/health_roulette.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/gnome_starman.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/yeet.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/crit_grenade_launcher.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/tank/rock_ambulance.mp3");
	AddFileToDownloadsTable("sound/kingo_chaos_edition/demoman/kaboom.mp3");
	
	
	char wak47[32] = "weapon_rifle_ak47";
	L4D2_SetFloatWeaponAttribute(wak47, L4D2FWA_CycleTime, 0.13);
	char awp[32] = "weapon_sniper_awp";
	L4D2_SetIntWeaponAttribute(awp, L4D2IWA_Damage, 115);
	
	g_randomCritActive = false;
}
public void OnMapEnd()
{
	if(H_StarManReapply != INVALID_HANDLE)
	{
		CloseHandle(H_StarManReapply);
		H_StarManReapply = INVALID_HANDLE;
	}
}

public void OnClientPutInServer(int client)
{
	g_GnomePickedUp[client] = 0;
	g_Cursed[client] = 0;
	g_NoFall[client] = 0;
	g_GodMode[client] = 0;
	g_demoManActive[client] = false;
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}