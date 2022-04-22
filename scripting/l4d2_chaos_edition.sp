#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <left4dhooks>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "2.0"
#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3
#define ZC_SMOKER 1
#define ZC_BOOMER 2
#define ZC_HUNTER 3
#define ZC_SPITTER 4
#define ZC_JOCKEY 5
#define ZC_CHARGER 6
#define ZC_WITCH 7
#define ZC_TANK 8

#define SOUND_METAL_MARIO "kingo_chaos_edition/metal_mario.mp3"
#define SOUND_HEALTH_ROULETTE "kingo_chaos_edition/health_roulette.mp3"
#define SOUND_HURRY_UP_BUILDUP "kingo_chaos_edition/hurry_up_buildup.mp3"
#define SOUND_HURRY_UP_LOOP "kingo_chaos_edition/hurry_up_loop.mp3"

#include <chaos/setup.sp>
#include <chaos/sdkcalls.sp>
#include <chaos/generic_events.sp>
#include <chaos/groovy.sp>
#include <chaos/movie_logic.sp>
#include <chaos/insult_to_injury.sp>
#include <chaos/suppressive_fire.sp>
#include <chaos/metal_mario.sp>
#include <chaos/health_roulette.sp>
#include <chaos/eye_for_an_eye.sp>
#include <chaos/witch_revenge.sp>
#include <chaos/hurry_up.sp>

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
    Handle hGameConf = new GameData("l4d2.chaos");
    if(!hGameConf) SetFailState("Could not find l4d2 chaos edition Gamedata!");
    Setup_SDKCalls(hGameConf);
    Setup_GenericEvents();
    Setup_Groovy();
    Setup_MovieLogic();
    Setup_InsultToInjury();
    Setup_SuppressiveFire();
    Setup_MetalMario();
    Setup_HealthRoulette();
    Setup_EyeForAnEye();
    Setup_WitchRevenge();
    Setup_HurryUp();
    delete hGameConf;
}

public void OnMapStart()
{
    //Precache
    
    //Sound Precache
    PrecacheSound(SOUND_METAL_MARIO);
    PrecacheSound(SOUND_HEALTH_ROULETTE);
    PrecacheSound(SOUND_HURRY_UP_BUILDUP);
    PrecacheSound(SOUND_HURRY_UP_LOOP);
    
    //Download Table
    
    AddFileToDownloadsTable("sound/kingo_chaos_edition/metal_mario.mp3");
    AddFileToDownloadsTable("sound/kingo_chaos_edition/health_roulette.mp3");
    AddFileToDownloadsTable("sound/kingo_chaos_edition/hurry_up_buildup.mp3");
    AddFileToDownloadsTable("sound/kingo_chaos_edition/hurry_up_loop.mp3");
    
    Reset_HurryUp();
}

public void OnGameFrame()
{
    HurryUp_Loop();
    if (HurryUp_TimerExpired())
    {
       for (int i = 1 ; i <= MaxClients ; i++)
        {
            if (GetClientTeam(i) == TEAM_SURVIVOR)HurryUp_DrainHealth(i);
        } 
    }
}

public void OnClientPutInServer(int client)
{
    Reset_MovieLogic(client);
    Reset_SuppressiveFire(client);
    Reset_MetalMario(client);
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
    SDKHook(client, SDKHook_StartTouch, OnStartTouch);
    SDKHook(client, SDKHook_Touch, OnStartTouch);
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float velocity[3], float angles[3], int &weapon)
{
    if (!IsPlayerAlive(client))return Plugin_Continue;
    
    if (IsSuppressiveFireActive(client))buttons |= IN_ATTACK;
    
    return Plugin_Continue;
}

static Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damageType, int &weapon, float damageForce[3], float damagePosition[3], int damageCustom)
{
    if (victim > 0 && victim <= MaxClients)
    {
        if(IsPlayerMetalMario(victim) && damageType & ~DMG_FALL)
        {
            damage = 0.0;
            return Plugin_Changed;
        }
    }
    return Plugin_Continue;
}

static Action OnStartTouch(int entity, int client)
{
    if(client > 0 && client <= MaxClients)
    {
        if(IsPlayerMetalMario(client))
        {
            if (entity > MaxClients)
            {
                SDKHooks_TakeDamage(entity, client, client, 150.0, DMG_CLUB, _, NULL_VECTOR, NULL_VECTOR);
            }
            else if (GetClientTeam(entity) != GetClientTeam(client))
            {
                SDKHooks_TakeDamage(entity, client, client, 150.0, DMG_CLUB, _, NULL_VECTOR, NULL_VECTOR);  
            }
        }
    }
    return Plugin_Continue;
}

public void OnEntityCreated(int entity, const char[] class)
{
    if(StrEqual(class, "infected", false))
    {
        SDKHook(entity, SDKHook_StartTouch, OnStartTouch);
        SDKHook(entity, SDKHook_Touch, OnStartTouch);
    }
}