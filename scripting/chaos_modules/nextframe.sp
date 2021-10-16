public void ProcessIncapFrame(int serial)
{
	int client = GetClientFromSerial(serial);
	if(CheckValidClient(client))
	{
		L4D2_IncapPlayer(client);
	}
}