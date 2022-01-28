static ConVar cvar;

void Setup_WitchRevenge()
{
    cvar = CreateChanceConVar("chaos_witch_revenge", "0.33");
    
}

void Roll_WitchRevenge(int client, bool bCrowned)
{
    if (bCrowned && IsPlayerAlive(client) && GetClientTeam(client) == TEAM_SURVIVOR) //Prevent tanks from killing witches in versus
    {
        if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetRandomFloat(0.0, 1.0))
        {
            float origin[3];
            GetEntPropVector(client, Prop_Send, "m_vecOrigin", origin);
            L4D2_SpawnTank(origin, NULL_VECTOR);
            PrintHintText(client, "Witch revenge!");
            for (int i = 1; i <= MaxClients; i++)
            {
                if (IsClientInGame(i))
                {
                    PrintHintText(i, "%N triggered witch revenge!", client);
                }
            }
        } 
    }
}