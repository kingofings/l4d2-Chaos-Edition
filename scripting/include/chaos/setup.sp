ConVar CreateChanceConVar(const char[] name, const char[] defaultValue)
{
    ConVar cvar = CreateConVar(name, defaultValue, "Chance is %", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    return cvar;
}

stock int GetIncapCount(int client)
{
    return GetEntProp(client, Prop_Send, "m_currentReviveCount");
}

void IncapPlayer(int client)
{
    SetEntPropFloat(client, Prop_Send, "m_healthBuffer", 0.0);
    SDKHooks_TakeDamage(client, client, client, float(GetEntProp(client, Prop_Send, "m_iHealth")), _, _, _, _);
}