static ConVar cvar;

void Setup_WitchRevenge()
{
    cvar = CreateChanceConVar("chaos_witch_revenge", "0.33");
}

void Roll_WitchRevenge(int attacker, int witch, bool bCrowned)
{
    if (bCrowned && GetClientTeam(attacker) == TEAM_SURVIVOR) 
    {
        if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetURandomFloat())
        {
            float origin[3], qAngles[3];
            GetEntPropVector(witch, Prop_Send, "m_vecOrigin", origin);
            GetClientEyeAngles(attacker, qAngles);
            ScaleVector(qAngles, -1.0);
            L4D2_SpawnTank(origin, qAngles);
            PrintHintTextToAll("%N triggered witch revenge!", attacker);
        } 
    }
}