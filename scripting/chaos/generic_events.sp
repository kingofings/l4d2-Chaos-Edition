void Setup_GenericEvents()
{
    HookEvent("weapon_fire", Event_WeaponFirePost, EventHookMode_Post);
    HookEvent("player_death", Event_PlayerDeathPost, EventHookMode_Post);
}

static void Event_WeaponFirePost(Event event, const char[] name, bool dontBroadcast)
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

static void Event_PlayerDeathPost(Event event, const char[] name, bool dontBroadcast)
{
    int victim = GetClientOfUserId(event.GetInt("userid"));
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    char weapon[64];
    event.GetString("weapon", weapon, sizeof(weapon));
    if (victim > 0 && victim <= MaxClients && IsClientInGame(victim) && attacker > 0 && attacker <= MaxClients && IsClientInGame(attacker))
    {
        Roll_Groovy(victim, attacker, weapon);
    }
    if (victim > 0 && victim <= MaxClients && IsClientInGame(victim))
    {
        End_SuppressiveFire(victim);
    }
}