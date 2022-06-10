static ConVar cvar;

void Setup_EyeForAnEye()
{
    cvar = CreateChanceConVar("chaos_eye_for_eye", "0.20");
}

void Roll_EyeForAnEye(int client, int victim)
{
    if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetURandomFloat())
    {
        if (IsPlayerAlive(client) && IsPlayerAlive(victim))
        {
            RequestFrame(ProcessIncap, GetClientSerial(client));
            Event event = CreateEvent("player_incapacitated");
            if(event)
            {
                event.SetInt("userid", GetClientUserId(client));
                event.SetInt("attacker", GetClientUserId(victim));
                for (int i = 1; i <= MaxClients; i++)
                {
                    if (IsClientInGame(i) && !IsFakeClient(i))event.FireToClient(i);
                }
            }
            delete event;
            RevivePlayer(victim);
            
            PrintHintText(client, "Eye for an Eye!");
            PrintHintText(victim, "%N Eye for an Eye! RISE!", client);
        }
    }
}

static void ProcessIncap(int serial)
{
    int client = GetClientFromSerial(serial);
    if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))IncapPlayer(client);
}