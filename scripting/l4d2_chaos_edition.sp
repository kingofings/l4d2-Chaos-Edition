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

#include <chaos/setup.sp>
#include <chaos/generic_events.sp>
#include <chaos/groovy.sp>
#include <chaos/movie_logic.sp>
#include <chaos/insult_to_injury.sp>
#include <chaos/suppressive_fire.sp>
#include <chaos/metal_mario.sp>

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
    Setup_GenericEvents();
    Setup_Groovy();
    Setup_MovieLogic();
    Setup_InsultToInjury();
    Setup_SuppressiveFire();
    Setup_MetalMario();
}

public void OnMapStart()
{
    //Precache
    
    //Sound Precache
    PrecacheSound(SOUND_METAL_MARIO);
    
    //Download Table
    
    AddFileToDownloadsTable("sound/kingo_chaos_edition/metal_mario.mp3");
}

public void OnClientPutInServer(int client)
{
    Reset_MovieLogic(client);
    Reset_SuppressiveFire(client);
    Reset_MetalMario(client);
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float velocity[3], float angles[3], int &weapon)
{
    if (!IsPlayerAlive(client))return;
    
    if (IsSuppressiveFireActive(client))buttons |= IN_ATTACK;
}

static Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damageType, int &weapon, float damageForce[3], float damagePosition[3], int damageCustom)
{
    if (victim > 0 && victim <= MaxClients)
    {
        if(IsPlayerMetalMario(victim))
        {
            damage = 0.0;
            return Plugin_Changed;
        }
    }
    return Plugin_Continue;
}