void SetupPlayerSDKHooks(int client)
{
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
    SDKHook(client, SDKHook_StartTouch, OnStartTouch);
    SDKHook(client, SDKHook_Touch, OnStartTouch);
}

void Setup_InfectedSDKHooks(int entity)
{
    SDKHook(entity, SDKHook_StartTouch, OnStartTouch);
    SDKHook(entity, SDKHook_Touch, OnStartTouch);
}

static Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damageType, int &weapon, float damageForce[3], float damagePosition[3], int damageCustom)
{
    if (victim > 0 && victim <= MaxClients)
    {
        if (Starman_IsActive(victim))
        {
            damage = 0.0;
            return Plugin_Changed;
        }
        if (IsPlayerMetalMario(victim) && damageType & ~DMG_FALL)
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
        if (IsPlayerMetalMario(client) || Starman_IsActive(client))
        {
            if (entity > MaxClients)SDKHooks_TakeDamage(entity, client, client, 150.0, DMG_CLUB, _, NULL_VECTOR, NULL_VECTOR);
            else if (GetClientTeam(entity) != GetClientTeam(client))SDKHooks_TakeDamage(entity, client, client, 150.0, DMG_CLUB, _, NULL_VECTOR, NULL_VECTOR);
        }
    }
    return Plugin_Continue;
}