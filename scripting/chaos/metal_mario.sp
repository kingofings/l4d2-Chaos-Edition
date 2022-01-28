static ConVar cvar;
static ConVar cvar_duration;
static bool g_bGodMode[MAXPLAYERS + 1];
static int g_iHealth[MAXPLAYERS + 1];
static float g_flBufferHealth[MAXPLAYERS + 1];
static float g_flDuration[MAXPLAYERS + 1];

void Setup_MetalMario()
{
    cvar = CreateChanceConVar("chaos_metal_mario", "0.10");
    cvar_duration = CreateConVar("chaos_metal_mario_duration", "10.0", "Duration in seconds", FCVAR_NOTIFY, true, 0.0);
}

void Roll_MetalMario(int client)
{
    if (IsPlayerAlive(client))
    {
        if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetRandomFloat(0.0, 1.0))
        {
            g_bGodMode[client] = true;
            g_iHealth[client] = GetEntProp(client, Prop_Send, "m_iHealth");
            g_flBufferHealth[client] = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
            g_flDuration[client] = GetGameTime() + cvar_duration.FloatValue;
            CreateTimer(0.1, Timer_MetalMario, GetClientSerial(client), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
            SetEntityRenderColor(client, 0, 0, 0, 255);
            for (int i = 100; i <= 103; i++)
            {
                EmitSoundToAll(SOUND_METAL_MARIO, client, i, SNDLEVEL_GUNFIRE, _, 1.0, _, _, _, _, true, _);
            }
        }
    }
}

static Action Timer_MetalMario(Handle timer, int serial)
{
    int client = GetClientFromSerial(serial);
    if(client > 0 && client <= MaxClients && IsClientInGame(client))
    {
        if(IsPlayerAlive(client) && g_flDuration[client] < GetGameTime())
        {
            SetEntProp(client, Prop_Send, "m_iHealth", GetRandomInt(1, 50));
            SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 50.0);
            return Plugin_Continue;
        }
        else
        {
            g_bGodMode[client] = false;
            SetEntProp(client, Prop_Send, "m_iHealth", g_iHealth[client]);
            SetEntPropFloat(client, Prop_Send, "m_bufferHealth", g_flBufferHealth[client]);
            SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
            SetEntityRenderColor(client, 255, 255, 255, 255);
            return Plugin_Stop;
        }
    }
    return Plugin_Continue;
}

bool IsPlayerMetalMario(int client)
{
    return g_bGodMode[client];
}

void Reset_MetalMario(int client)
{
    g_bGodMode[client] = false;
    g_iHealth[client] = 0;
    g_flBufferHealth[client] = 0.0;
    g_flDuration[client] = 0.0;
}