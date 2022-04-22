static ConVar cvar;

void Setup_EyeForAnEye()
{
    cvar = CreateChanceConVar("chaos_eye_for_eye", "0.20");
}

void Roll_EyeForAnEye(int client, int victim)
{
    if (cvar.FloatValue == 1.0 || cvar.FloatValue > GetRandomFloat(0.0, 1.0))
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
                {   //L4D Does not support sending events to bots!
                    if (IsClientInGame(i) && !IsFakeClient(i))event.FireToClient(i);
                }
            }
            RevivePlayer(victim);
            event = CreateEvent("revive_success");
            if (event)
            {
                event.SetInt("userid", GetClientOfUserId(victim));
                event.SetInt("attacker", GetClientOfUserId(client));
                for (int i = 1; i <= MaxClients; i++)
                {
                    if (IsClientInGame(i) && !IsFakeClient(i))event.FireToClient(i);
                }
            }
            delete event;
            
            PrintHintText(client, "Eye for an Eye!");
            PrintHintText(victim, "%N Eye for an Eye! RISE!", client);
        }
    }
}

void ProcessIncap(int serial)
{
    int client = GetClientFromSerial(serial);
    if (client > 0 && client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))IncapPlayer(client);
}