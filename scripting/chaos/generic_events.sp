void Setup_GenericEvents()
{
    HookEvent("weapon_fire", Event_WeaponFirePost, EventHookMode_Post);
    HookEvent("player_death", Event_PlayerDeathPost, EventHookMode_Post);
    HookEvent("round_start", Event_Reset, EventHookMode_Post);
    HookEvent("round_end", Event_Reset, EventHookMode_Post);
    HookEvent("pills_used", Event_PillsUsedPost, EventHookMode_Post);
}

static void Event_WeaponFirePost(Event event, const char[] name, bool bDontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    char weapon[64];
    event.GetString("weapon", weapon, sizeof(weapon));
    if (client > 0 && client <= MaxClients)
    {
        Roll_MovieLogic(client, weapon);   
        Roll_SuppressiveFire(client, weapon);
    }
}

static void Event_PlayerDeathPost(Event event, const char[] name, bool bDontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("userid"));
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    bool bValidVictim;
    bool bValidAttacker;
    char weapon[64];
    event.GetString("weapon", weapon, sizeof(weapon));
   
    if (victim > 0 && victim <= MaxClients && IsClientInGame(victim))
    {
        bValidVictim = true;
        Reset_SuppressiveFire(victim);
    }
    if (attacker > 0 && attacker <= MaxClients && IsClientInGame(attacker))
    {
        bValidAttacker = true;
    }
    if (bValidVictim && bValidAttacker)
    {
        Roll_Groovy(victim, attacker, weapon);
    }
}

static void Event_Reset(Event event, const char[] name, bool bDontBroadcast)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        Reset_MovieLogic(i);
        Reset_SuppressiveFire(i);
        Reset_MetalMario(i);
    }
    PrintToServer("[CHAOS] Reset Global Variables of all Players");    
}

static void Event_PillsUsedPost(Event event, const char[] name, bool bDontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("subject"));
    if(client > 0 && client <= MaxClients && IsClientInGame(client))
    {
        Roll_MetalMario(client);
    }
}