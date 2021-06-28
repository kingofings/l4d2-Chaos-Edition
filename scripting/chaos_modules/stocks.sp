stock bool CheckValidClient(int client)
{
	if(client <= 0)
		return false;
		
	if (client > MaxClients)
		return false;

	if(!IsClientInGame(client))
		return false;

	if(!IsPlayerAlive(client))
		return false;

	if(IsClientSourceTV(client))
		return false;

	return true;
}