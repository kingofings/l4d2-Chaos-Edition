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
// May be used later currently broken
/*SetTeleportEndPoint(client)
{
	float vEyePos[3];
	float vEyeAngles[3];
	float vStart[3];
	float vBuffer[3];
	float distance;
	Handle trace = TR_TraceRayFilterEx(vEyePos, vEyeAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);
	GetClientEyePosition(client, vEyePos);
	GetClientEyeAngles(client, vEyeAngles);
	if(TR_DidHit(trace))
	{
		TR_GetEndPosition(vStart, trace);
		GetVectorDistance(vEyePos, vStart, false);
		distance = -35.0;
		GetAngleVectors(vEyeAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		g_pos[0] = vStart[0] + (vBuffer[0]*distance);
		g_pos[1] = vStart[1] + (vBuffer[1]*distance);
		g_pos[2] = vStart[2] + (vBuffer[2]*distance);
	}
	else
	{
		CloseHandle(trace);
		return false;
	}
	CloseHandle(trace);
	return true;
}

public bool:TraceEntityFilterPlayer(entity, contentsMask)
{
	return entity > MaxClients || !entity;
}*/