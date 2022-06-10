static ConVar cvar;

void Setup_HealthRoulette()
{
    cvar = CreateChanceConVar("chaos_health_roulette", "0.15");
}

void Roll_HealthRoulette(int client)
{
    if (IsPlayerAlive(client))
    {
        if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetURandomFloat())
        {
            DataPack pack;
            CreateDataTimer(0.1, Timer_HealthRoulette, pack, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
            pack.WriteCell(GetClientSerial(client));
            pack.WriteFloat(GetGameTime() + 3.45);
            for (int i = 100; i <= 103; i++)
            {
                EmitSoundToAll(SOUND_HEALTH_ROULETTE, client, i, SNDPITCH_NORMAL, _, 1.0, _, _, _, _, true, _);
            }
            PrintHintText(client, "Health roulette!");
            
        }
    }
}

static Action Timer_HealthRoulette(Handle timer, DataPack pack)
{
    pack.Reset();
    int client = GetClientFromSerial(pack.ReadCell());
    float flGameTime = GetGameTime();
    if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
    {
        if (pack.ReadFloat() > flGameTime)
        {
            SetEntProp(client, Prop_Send, "m_iHealth", GetRandomInt(1, 100));
            SetEntPropFloat(client, Prop_Send, "m_healthBuffer", GetRandomFloat(0.0, 100.0));
            SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", flGameTime);
            return Plugin_Continue;
        }
        else
        {
            int iHealth = GetEntProp(client, Prop_Send, "m_iHealth");
            float flBuffer = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
            PrintHintText(client, "Permanent Health: %i. Temporary Health: %0.2f. Total health: %0.2f", iHealth, flBuffer, iHealth + flBuffer);
            return Plugin_Stop;
        }
    }
    else return Plugin_Stop;
}