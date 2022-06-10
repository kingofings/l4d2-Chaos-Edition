void Setup_GenericEvents()
{
    HookEvent("weapon_fire", Event_WeaponFirePost, EventHookMode_Post);
    HookEvent("player_death", Event_PlayerDeathPost, EventHookMode_Post);
    HookEvent("round_start", Event_Reset, EventHookMode_Post);
    HookEvent("round_end", Event_Reset, EventHookMode_Post);
    HookEvent("pills_used", Event_PillsUsedPost, EventHookMode_Post);
    HookEvent("revive_end", Event_ReviveEndPost, EventHookMode_Post);
    HookEvent("witch_killed", Event_WitchKilledPost, EventHookMode_Post);
    HookEvent("door_open", Event_DoorOpenPost, EventHookMode_Post);
    HookEvent("charger_carry_start", Event_ChargerCarryStartPost, EventHookMode_Post);
    HookEvent("item_pickup", Event_ItemPickupPost, EventHookMode_Post);
}

static void Event_WeaponFirePost(Event event, const char[] name, bool bDontBroadcast)
{
    if (HurryUp_IgnoreOtherEffects())return;
    
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
    if (HurryUp_IgnoreOtherEffects())return;
    
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
        Silence_HurryUp(i);
    }
    Reset_HurryUp();
    PrintToServer("[CHAOS] Reset Global Variables of all Players");    
}

static void Event_PillsUsedPost(Event event, const char[] name, bool bDontBroadcast)
{
    if (HurryUp_IgnoreOtherEffects())return;
    
    int client = GetClientOfUserId(event.GetInt("subject"));
    if(client > 0 && client <= MaxClients && IsClientInGame(client))
    {
        Roll_MetalMario(client);
        Roll_HealthRoulette(client);
    }
}

static void Event_ReviveEndPost(Event event, const char[] name, bool bDontBroadcast)
{
    if (HurryUp_IgnoreOtherEffects())return;
    
    int client = GetClientOfUserId(event.GetInt("userid"));
    int victim = GetClientOfUserId(event.GetInt("subject"));
    bool bValidClient;
    bool bValidVictim;
   
    if (client > 0 && client <= MaxClients && IsClientInGame(client))
    {
        bValidClient = true;
    }
    if (victim > 0 && victim <= MaxClients && IsClientInGame(victim))
    {
        bValidVictim = true;
    }
    if (bValidVictim && bValidClient)
    {
        Roll_EyeForAnEye(client, victim);
    }
}

static void Event_WitchKilledPost(Event event, const char[] name, bool bDontBroadcast)
{
    if (HurryUp_IgnoreOtherEffects())return;
    
    bool bCrowned = event.GetBool("oneshot");
    int attacker = GetClientOfUserId(event.GetInt("userid"));
    int witch = event.GetInt("witchid");
    
    bool validAttacker, validWitch;
    
    if (attacker > 0 && attacker <= MaxClients)validAttacker = true;
    if (IsValidEntity(witch))validWitch = true;

    if (validAttacker && validWitch)
    {
        Roll_WitchRevenge(attacker, witch, bCrowned);
    }
}

static void Event_DoorOpenPost(Event event, const char[] name, bool bDontBroadcast)
{
    if (HurryUp_IgnoreOtherEffects())return;
    
    bool bCheckPoint = event.GetBool("checkpoint");
    if (bCheckPoint)
    {
        Roll_HurryUp();
    }
}

static void Event_ChargerCarryStartPost(Event event, const char[] name, bool dontBroadcast)
{
    if (HurryUp_IgnoreOtherEffects())return;
    
    int victim = GetClientOfUserId(event.GetInt("victim"));
    if(victim > 0 && victim <= MaxClients && IsClientInGame(victim))
    {
        Roll_InsultToInjury(victim);
    }
}

static void Event_ItemPickupPost(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if (!client)return;
    char item[128];
    event.GetString("item", item, sizeof(item));
    
    Roll_StarmanGnome(client, item);
}