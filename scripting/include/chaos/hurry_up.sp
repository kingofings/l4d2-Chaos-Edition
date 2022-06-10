static bool g_rolled;
static bool g_bHurryUp;
static bool g_bHurryUpBuildUp;
static bool g_bHurryUpNoTime;
static float g_flHurryUpLoopTime;
static float g_flDrainedHealth;
static int g_time;
static int g_normal_time;
static int g_hard_time;
static ConVar cvar;
static ConVar cvar_duration;
static ConVar cvar_ignore;
static ConVar cvar_difficulty;


void Setup_HurryUp()
{
    cvar = CreateChanceConVar("chaos_hurry_up", "0.15");
    cvar_duration = CreateConVar("chaos_hurry_up_drain", "15.0", "Amount in seconds it takes to drain health", FCVAR_NOTIFY, true, 0.0);
    cvar_ignore = CreateConVar("chaos_hurry_up_ignore", "1", "Disable any other effects while hurry up is active", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    cvar_difficulty = CreateConVar("chaos_hurry_up_difficulty", "1", "0 = Random, 1 = Normal, 2 = Hard", FCVAR_NOTIFY, true, 1.0, true, 2.0);
}

void Roll_HurryUp()
{
    if (g_rolled)return;
    if (g_bHurryUp)return;
    if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetURandomFloat())
    {
        g_bHurryUp = true;
        int difficulty = HurryUp_GetDifficultyLevel();
        if (g_normal_time <= 0)difficulty = 2;
        else if (g_hard_time <= 0)difficulty = 1;
        switch (difficulty)
        {
            case 0:
            {
                if (GetRandomInt(1, 2) == 1)g_time = g_normal_time;
                else g_time = g_hard_time;
            }
            case 1:g_time = g_normal_time;
            case 2:g_time = g_hard_time;
        }
        CreateTimer(1.0, Timer_HurryUp, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
        PrintHintTextToAll("%i:%02i", g_time / 60, g_time % 60);
    }
    HurryUp_SetStatus(true);
}

static Action Timer_HurryUp(Handle timer)
{
    if(!g_bHurryUp || g_time <= 0)
    {
        return Plugin_Stop;
    }
    g_time--;
    if (g_time <= 0)
    {
        for (int i = 1 ; i <= MaxClients ; i++)
        {
            if (IsClientInGame(i))Silence_HurryUp(i);
        }
        g_bHurryUpNoTime = true;
        g_flHurryUpLoopTime = GetGameTime();
    }
    PrintHintTextToAll("%i:%02i", g_time / 60, g_time % 60);
    //Make Wario scream Hurry up! every minute!
    char hurryUp[128];
    int RNG = GetRandomInt(1, 5);
    Format(hurryUp, sizeof(hurryUp), "kingo_chaos_edition/voice/wario/hurry_up%i.mp3", RNG);
    
    if (g_time == 10)
    {
        for (int i = 1 ; i <= 3 ; i++)
        {
            EmitSoundToAll(SOUND_HURRY_UP_10_SECONDS, _, 106 + i, SNDLEVEL_AIRCRAFT);
        }
    }
    if (g_time % 60 == 0 && g_time >= 60)
    {
        for (int i = 1 ; i <= 3 ; i++)
        {
            EmitSoundToAll(hurryUp, _, 103 + i, SNDLEVEL_AIRCRAFT);
        }
    }
    else
    {
        switch (g_time)
        {
            case 45, 30, 15, 0:
            {
                for (int i = 1 ; i <= 3 ; i++)
                {
                    EmitSoundToAll(hurryUp, _, 103 + i, SNDLEVEL_AIRCRAFT);
                }
            }
        }
    }
    return Plugin_Continue;
}

void HurryUp_Loop()
{
    //this is quite annoying yes you could set loop cues with wav files but l4d does not play custom ones without rebuilding audio cache...
    if (!g_bHurryUp)return;
    
    if (!g_bHurryUpBuildUp)
    {
        for (int i = 1 ; i <= 3 ; i++)
        {
            EmitSoundToAll(SOUND_HURRY_UP_BUILDUP, _, 100 + i, SNDLEVEL_AIRCRAFT);
        }
        g_flHurryUpLoopTime = GetGameTime() + 118.524;
        g_bHurryUpBuildUp = true;
    }
    
    if (GetGameTime() > g_flHurryUpLoopTime)
    {
        if (g_bHurryUpNoTime)
        {
            for (int i = 1 ; i <= 3 ; i++)
            {
                EmitSoundToAll(SOUND_HURRY_UP_NO_TIME, _, 100 + i, SNDLEVEL_AIRCRAFT);
            }
            g_flHurryUpLoopTime = GetGameTime() + 16.090;
        }
        else
        {
            for (int i = 1 ; i <= 3 ; i++)
            {
            EmitSoundToAll(SOUND_HURRY_UP_LOOP, _, 100 + i, SNDLEVEL_AIRCRAFT);
            }
            g_flHurryUpLoopTime = GetGameTime() + 34.708;
        }
    }
}

void HurryUp_DrainHealth(int client)
{
    if (!IsPlayerAlive(client))return;
    float flBuffer = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
    if (flBuffer > 0.0)
    {
        flBuffer -= GetGameFrameTime() / (cvar_duration.FloatValue / 100.0);
        if (flBuffer < 0.0)SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
        else SetEntPropFloat(client, Prop_Send, "m_healthBuffer", flBuffer);
    }
    else
    {
        int iHealth = GetEntProp(client, Prop_Send, "m_iHealth");
        
        if(iHealth > 0)
        {
            g_flDrainedHealth += (GetGameFrameTime() / (cvar_duration.FloatValue / 100.0));
            if (g_flDrainedHealth >= 1.0)
            {
                if (iHealth <= 1)IncapPlayer(client);
                else SetEntProp(client, Prop_Send, "m_iHealth", RoundToNearest(iHealth - g_flDrainedHealth));
                g_flDrainedHealth--;
            }
        }
    }
}
void Reset_HurryUp()
{
    HurryUp_SetStatus(false);
    g_bHurryUp = false;
    g_bHurryUpBuildUp = false;
    g_bHurryUpNoTime = false;
    g_flHurryUpLoopTime = 0.0;
    g_flDrainedHealth = 0.0;
    g_time = 0;
}

void Silence_HurryUp(int client)
{
    for (int i = 1 ; i <= 3; i++)
    {
        StopSound(client, 100 + i, SOUND_HURRY_UP_LOOP);
        StopSound(client, 100 + i, SOUND_HURRY_UP_BUILDUP);
        StopSound(client, 100 + i, SOUND_HURRY_UP_NO_TIME);
    }
}

bool HurryUp_IgnoreOtherEffects()
{
    if (g_bHurryUp)return cvar_ignore.BoolValue;
    
    return false;
}

bool HurryUp_TimerExpired()
{
    if (HurryUp_IsActive() && g_time <= 0)return true;
    
    return false;
}

bool HurryUp_IsActive()
{
    return g_bHurryUp;
}

/**
* Purpose: Manually set it to rolled or unrolled.
**/
static void HurryUp_SetStatus(bool status)
{
    g_rolled = status;
}

static int HurryUp_GetDifficultyLevel()
{
    return cvar_difficulty.IntValue;
}

/**
* Parse Map time config
**/
void HurryUp_ParseKV(const char[] mapName)
{
    char path[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, path, sizeof(path), "configs/chaos_hurryup.cfg");
    if (!FileExists(path))SetFailState("Hurry up config file %s does not exist!", path);
    
    KeyValues kv = new KeyValues("chaos_hurryup");
    if (!kv.ImportFromFile(path))SetFailState("Unable to parse KeyValues file %s", path);
    if (!kv.JumpToKey(mapName))
    {
        LogMessage("[HURRY UP] Map has no config disabling hurry up roll!");
        HurryUp_SetStatus(true);
        delete kv;
        return;
    }
    
    g_normal_time = kv.GetNum("normal", 0);
    g_hard_time = kv.GetNum("hard", 0);
    if (g_normal_time <= 0 && g_hard_time <= 0)
    {
        LogMessage("[HURRY UP] No valid time values found please check your config!");
        HurryUp_SetStatus(true);
    }
    
    delete kv;
}