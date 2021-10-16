public void ProcessIncapFrame(int serial)
{
	int client = GetClientSerial(serial);
	if(CheckValidClient(client))
	{
		L4D2_IncapPlayer(client);
	}
}