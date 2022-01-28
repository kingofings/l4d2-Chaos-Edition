static ConVar cvar;
static ConVar cvar_duration;
static bool g_bGodMode[MAXPLAYERS + 1];

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
            DataPack pack;
            CreateDataTimer(0.1, Timer_MetalMario, pack, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
            pack.WriteCell(GetClientSerial(client));
            pack.WriteCell(GetEntProp(client, Prop_Send, "m_iHealth"));
            pack.WriteFloat(GetEntPropFloat(client, Prop_Send, "m_healthBuffer"));
            pack.WriteFloat(GetGameTime() + cvar_duration.FloatValue);
            SetEntityRenderColor(client, 0, 0, 0, 255);
            for (int i = 100; i <= 102; i++)
            {
                EmitSoundToAll(SOUND_METAL_MARIO, client, i, SNDLEVEL_GUNFIRE, _, 1.0, _, _, _, _, true, _);
            }
            PrintHintText(client, "Metal Mario!");
        }
    }
}

static Action Timer_MetalMario(Handle timer, DataPack pack)
{
    pack.Reset();
    int client = GetClientFromSerial(pack.ReadCell());
    int iHealth = pack.ReadCell();
    float flHealthBuffer = pack.ReadFloat();
    if(client > 0 && client <= MaxClients && IsClientInGame(client))
    {
        if(IsPlayerAlive(client) && pack.ReadFloat() > GetGameTime())
        {
            SetEntProp(client, Prop_Send, "m_iHealth", GetRandomInt(1, 50));
            SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 50.0);
            return Plugin_Continue;
        }
        else
        {
            g_bGodMode[client] = false;
            SetEntProp(client, Prop_Send, "m_iHealth", iHealth);
            SetEntPropFloat(client, Prop_Send, "m_healthBuffer", flHealthBuffer);
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
}