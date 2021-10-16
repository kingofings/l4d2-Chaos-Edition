public void ProcessIncapFrame(int serial)
{
	int client = GetClientFromSerial(serial);
	if(CheckValidClient(client))
	{
		L4D2_IncapPlayer(client);
	}
}

public void OnKarmaLaunchVomitJar(int entityRefrence)
{
	int entity = EntRefToEntIndex(entityRefrence);
	if(IsValidEntity(entity))
	{
		float velocity[3];
		velocity[0] = GetRandomFloat(-500.0, 500.0);
		velocity[1] = GetRandomFloat(-500.0, 500.0);
		velocity[2] = GetRandomFloat(50.0, 500.0);
		TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, velocity);
		PrintToServer("Velocity: %f, %f, %f", velocity[0], velocity[1], velocity[2]);
	}
}

public void ProcessYeet(int serial)
{
	int client = GetClientFromSerial(serial);
	if(CheckValidClient(client))
	{
		float velocity[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", velocity);
		velocity[0] += GetRandomFloat(-800.0, 800.0); /* x coord */
		velocity[1] += GetRandomFloat(-800.0, 800.0); /* y coord */
		velocity[2] += GetRandomFloat(1.0, 800.0); /* z coord */
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity);
	}
}
