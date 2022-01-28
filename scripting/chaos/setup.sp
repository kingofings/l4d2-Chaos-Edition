ConVar CreateChanceConVar(const char[] name, const char[] defaultValue)
{
    ConVar cvar = CreateConVar(name, defaultValue, "Chance is %", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    return cvar;
}