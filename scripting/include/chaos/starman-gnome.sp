static float g_duration[2] = { 19.848, 13.229};
static float g_delay[MAXPLAYERS + 1];
static bool g_firstRun[MAXPLAYERS + 1];
static bool g_starManActive[MAXPLAYERS + 1];
static int g_gnomeEntity[MAXPLAYERS + 1] = { -1, ... };
static ConVar cvar;
void Setup_StarmanGnome()
{
    cvar = CreateChanceConVar("chaos_starman_chance", "0.01");
}

void Roll_StarmanGnome(int client, const char[] item)
{
    if (HurryUp_IgnoreOtherEffects())return;
    
    if (!StrEqual(item, "gnome", false))return;
    
    if (cvar.FloatValue >= 1.0 || cvar.FloatValue > GetURandomFloat())
    {
        g_delay[client] = GetGameTime() + g_duration[0];
        g_firstRun[client] = true;
        g_gnomeEntity[client] = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
        g_starManActive[client] = true;
        SetEntProp(client, Prop_Send, "m_iHealth", 100);
        SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
        SDKHook(client, SDKHook_PreThinkPost, Starman_Loop);
        for (int i = 1 ; i <= 3 ; i++)
        {
            EmitSoundToAll(STARMAN_STARTUP, _, 103 + i, SNDLEVEL_AIRCRAFT);
        }
    }
}

static void Starman_Loop(int client)
{
    if (!IsPlayerAlive(client) || GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") != g_gnomeEntity[client])
    {
        for (int i = 1 ; i <= MaxClients ; i++)
        {
            if (IsClientInGame(i))Silence_Starman(i);
        }
        Starman_ResetVars(client);
        SDKUnhook(client, SDKHook_PreThinkPost, Starman_Loop);
        return;
    }
    
    if (g_firstRun[client] && g_delay[client] <= GetGameTime())
    {
        for (int i = 1 ; i <= 2 ; i++)
        {
            EmitSoundToAll(STARMAN_LOOP, _, 100 + i, SNDLEVEL_AIRCRAFT);
        }
        
        g_firstRun[client] = false;
        g_delay[client] = g_duration[1] + GetGameTime();
    }
    else if (g_delay[client] <= GetGameTime())
    {
        for (int i = 1 ; i <= 2 ; i++)
        {
            EmitSoundToAll(STARMAN_LOOP, _, 100 + i, SNDLEVEL_AIRCRAFT);
        }
        g_delay[client] = g_duration[1] + GetGameTime();
    }
    SetEntityRenderColor(client, GetRandomInt(0, 255), GetRandomInt(0, 255), GetRandomInt(0, 255), 255);
    SetEntPropFloat(client, Prop_Send, "m_TimeForceExternalView", GetGameTime() + 0.1);
    
    for (int i = 1 ; i <= 2048 ; i++)
    {
        if (IsValidEntity(i))
        {
            float absOriginClient[3], absOriginTarget[3];
            if (i <= MaxClients && GetClientTeam(i) == TEAM_INFECTED)
            {
                GetClientAbsOrigin(client, absOriginClient);
                GetClientAbsOrigin(i, absOriginTarget);
                if (GetVectorDistance(absOriginClient, absOriginTarget) <= 150.0)SDKHooks_TakeDamage(i, client, client, 150.0, DMG_CLUB, _, NULL_VECTOR, NULL_VECTOR);
                continue;
            }
            
            char name[32];
            GetEdictClassname(i, name, sizeof(name));
            if (StrEqual(name, "infected", false))
            {
                GetClientAbsOrigin(client, absOriginClient);
                GetEntPropVector(i, Prop_Send, "m_vecOrigin", absOriginTarget);
                if (GetVectorDistance(absOriginClient, absOriginTarget) <= 150.0)SDKHooks_TakeDamage(i, client, client, 150.0, DMG_CLUB, _, NULL_VECTOR, NULL_VECTOR);
                continue;
            }
        }
    }
    
}

void Silence_Starman(int client)
{
    for (int i = 1 ; i <= 3; i++)
    {
        StopSound(client , 103 + i, STARMAN_STARTUP);
        StopSound(client , 100 + i, STARMAN_LOOP);
    }
}

void Starman_ResetVars(int client)
{
    g_delay[client] = 0.0;
    g_firstRun[client] = true;
    g_gnomeEntity[client] = -1;
    g_starManActive[client] = false;
    SetEntityRenderColor(client, 255, 255, 255, 255);
}

bool Starman_IsActive(int client)
{
    return g_starManActive[client];
}