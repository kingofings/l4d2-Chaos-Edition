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

/*  Thanks Silvers!
	All of the below stocks are made by him!*/
stock void CreateParticle(int target, int type)
{
	int entity = CreateEntityByName("info_particle_system");
	if( type == 0 )	DispatchKeyValue(entity, "effect_name", PARTICLE_FUSE);
	else			DispatchKeyValue(entity, "effect_name", PARTICLE_LIGHT);

	DispatchSpawn(entity);
	ActivateEntity(entity);
	AcceptEntityInput(entity, "Start");

	SetVariantString("!activator");
	AcceptEntityInput(entity, "SetParent", target);

	if( type == 0 )	SetVariantString("fuse");
	else			SetVariantString("pipebomb_light");
	AcceptEntityInput(entity, "SetParentAttachment", target);
}

stock void PrecacheParticle(const char[] sEffectName)
{
	static int table = INVALID_STRING_TABLE;
	if( table == INVALID_STRING_TABLE )
	{
		table = FindStringTable("ParticleEffectNames");
	}

	if( FindStringIndex(table, sEffectName) == INVALID_STRING_INDEX )
	{
		bool save = LockStringTables(false);
		AddToStringTable(table, sEffectName);
		LockStringTables(save);
	}
}