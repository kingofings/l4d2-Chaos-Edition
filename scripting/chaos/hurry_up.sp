static bool g_rolled;
static bool g_bHurryUp = false;
static bool g_bHurryUpBuildUp;
static float g_flHurryUpLoopTime;
static int g_time;
static ConVar cvar;
static ConVar cvar_duration;
static ConVar cvar_ignore;

void Setup_HurryUp()
{
    cvar = CreateChanceConVar("chaos_hurry_up", "0.15");
    cvar_duration = CreateConVar("chaos_hurry_up_drain", "15.0", "Amount in seconds it takes to drain health", FCVAR_NOTIFY, true, 0.0);
    cvar_ignore = CreateConVar("chaos_hurry_up_ignore", "1", "Disable any other effects while hurry up is active", FCVAR_NOTIFY, true, 0.0, true, 1.0);
}

void Roll_HurryUp()
{
    if (g_rolled)return;
    if (g_bHurryUp)return;
    if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetRandomFloat(0.0, 1.0))
    {
        g_bHurryUp = true;
        int minutes = GetRandomInt(5, 8);
        int seconds = GetRandomInt(0, 59);
        g_time = (minutes * 60) + seconds;
        CreateTimer(1.0, Timer_HurryUp, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
        PrintHintTextToAll("%i:%02i", g_time / 60, g_time % 60);
    }
    g_rolled = true;
}

static Action Timer_HurryUp(Handle timer)
{
    if(!g_bHurryUp || g_time <= 0)
    {
        return Plugin_Stop;
    }
    g_time--;
    PrintHintTextToAll("%i:%02i", g_time / 60, g_time % 60);
    // TODO Make Wario scream Hurry up! every minute!
    /*if (g_time % 60 == 0)
    {
        for (int i = 1 ; i <= MaxClients ; i++)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                switch(GetRandomInt(0, 5);)
                {
                    case 1:
                    {
                        //will do for now...
                        for (int j = 1 ; j <= 3; j++)
                        {
                            EmitSoundToClient(i, SOUND_WARIO_HURRY_UP, i, 100 + j, SNDLEVEL_AIRCRAFT, _, 1.0, _, _, _, _, _, _);
                        }
                    }
                }
            }
        }
    }*/
    return Plugin_Continue;
}

void HurryUp_Loop()
{
    //this is quite annoying yes you could set loop cues with wav files but l4d does not play custom ones without rebuilding audio cache...
    if (!g_bHurryUp)return;
    
    if (!g_bHurryUpBuildUp)
    {
        for (int i = 1 ; i <= MaxClients ; i++)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                //This is stupid will do for now
                EmitSoundToClient(i, SOUND_HURRY_UP_BUILDUP, i, 101, SNDLEVEL_AIRCRAFT, _, 1.0, _, _, _, _, _, _);
                EmitSoundToClient(i, SOUND_HURRY_UP_BUILDUP, i, 102, SNDLEVEL_AIRCRAFT, _, 1.0, _, _, _, _, _, _);
                EmitSoundToClient(i, SOUND_HURRY_UP_BUILDUP, i, 103, SNDLEVEL_AIRCRAFT, _, 1.0, _, _, _, _, _, _);
            }
        }
        g_flHurryUpLoopTime = GetGameTime() + 118.524;
        g_bHurryUpBuildUp = true;
    }
    
    if (GetGameTime() > g_flHurryUpLoopTime)
    {
        for (int i = 1 ; i <= MaxClients ; i++)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                //This is stupid will do for now
                EmitSoundToClient(i, SOUND_HURRY_UP_LOOP, i, 101, SNDLEVEL_AIRCRAFT, _, 1.0, _, _, _, _, _, _);
                EmitSoundToClient(i, SOUND_HURRY_UP_LOOP, i, 102, SNDLEVEL_AIRCRAFT, _, 1.0, _, _, _, _, _, _);
                EmitSoundToClient(i, SOUND_HURRY_UP_LOOP, i, 103, SNDLEVEL_AIRCRAFT, _, 1.0, _, _, _, _, _, _);
            }
        }
        g_flHurryUpLoopTime = GetGameTime() + 34.708;
    }
}

void HurryUp_DrainHealth(int client)
{
    if (!IsPlayerAlive(client))return;
    float flBuffer = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
    if (flBuffer > 0.0)
    {
        flBuffer -= GetGameFrameTime() * cvar_duration.FloatValue;
        if (flBuffer < 0.0)SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
        else SetEntPropFloat(client, Prop_Send, "m_healthBuffer", flBuffer);
    }
    else
    {
        float flHealth = float(GetEntProp(client, Prop_Send, "m_iHealth"));
        
        if(flHealth > 0.0)
        {
            flHealth -= GetGameFrameTime() * cvar_duration.FloatValue;
            int iHealth = RoundToNearest(flHealth);
            if (iHealth <= 1)SlapPlayer(client, 100, false);
            else SetEntProp(client, Prop_Send, "m_iHealth", iHealth);
        }
    }
}
void Reset_HurryUp()
{
    g_rolled = false;
    g_bHurryUp = false;
    g_bHurryUpBuildUp = false;
    g_flHurryUpLoopTime = 0.0;
    g_time = 0;
}

void Silence_HurryUp(int client)
{
    for (int i = 1 ; i <= 3; i++)
    {
        StopSound(client, 100 + i, SOUND_HURRY_UP_LOOP);
        StopSound(client, 100 + i, SOUND_HURRY_UP_BUILDUP);
    }
}

bool HurryUp_IgnoreOtherEffects()
{
    if (g_bHurryUp)return cvar_ignore.BoolValue;
    
    return false;
}

bool HurryUp_TimerExpired()
{
    if (HurryUp_IsActive())return false;
    if (g_time <= 0)return true;
    
    return false;
}

bool HurryUp_IsActive()
{
    return g_bHurryUp;
}