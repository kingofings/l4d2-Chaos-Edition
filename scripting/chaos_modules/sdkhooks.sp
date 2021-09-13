public Action OnTakeDamage(int client, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if(g_NoFall[client] == 1 && CheckValidClient(client) && damagetype & DMG_FALL && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		return Plugin_Handled;
	}
	if(g_GodMode[client] == 1 && CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action OnPipeBombThink(int entity)
{
	int RNG = GetRandomInt(1, 5);
	if(RNG == 1)
	{
		float vel[3];
		float pos[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
		GetEntPropVector(entity, Prop_Send, "m_vecVelocity", vel);
		PrintToChatAll("Pipebomb spawned, Velocity: %f, %f, %f", vel[0], vel[1], vel[2]);
		int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
		if(g_demoManActive[owner])
		{
			SetEntPropFloat(entity, Prop_Data, "m_flDetonateTime", GetEngineTime() + 7.0);
		}
		if(!g_demoManActive[owner])
		{
			g_demoManActive[owner] = true;
		
			SetEntPropFloat(entity, Prop_Data, "m_flDetonateTime", GetEngineTime() + 7.0);
			//This is horrible but will do for now :) vectors are confusing 
			int newPipe[27];
			pos[2] += 150.0;
			newPipe[0] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] -= 150.0;
			newPipe[1] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[2] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] -= 300.0;
			newPipe[3] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] += 300.0;
			newPipe[4] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[5] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[6] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] -= 150.0;
			newPipe[7] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] -= 300.0;
			newPipe[8] = L4D_PipeBombPrj(owner, pos, vel);
			
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
		
			newPipe[9] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] -= 150.0;
			newPipe[10] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[11] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] -= 300.0;
			newPipe[12] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] += 300.0;
			newPipe[13] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[14] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[15] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] -= 150.0;
			newPipe[16] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] -= 300.0;
			newPipe[17] = L4D_PipeBombPrj(owner, pos, vel);
		
			GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
		
			pos[2] -= 150.0;
			newPipe[18] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] -= 150.0;
			newPipe[19] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[20] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] -= 300.0;
			newPipe[21] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] += 300.0;
			newPipe[22] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[23] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] += 150.0;
			newPipe[24] = L4D_PipeBombPrj(owner, pos, vel);
			pos[1] -= 150.0;
			newPipe[25] = L4D_PipeBombPrj(owner, pos, vel);
			pos[0] -= 300.0;
			newPipe[26] = L4D_PipeBombPrj(owner, pos, vel);
		
			for (int i = 1; i <= sizeof(newPipe) -1; i++)
			{
				CreateParticle(newPipe[i], 0);
				SetEntPropFloat(newPipe[i], Prop_Data, "m_flDetonateTime", GetEngineTime() + 7.0);
			}
			CreateTimer(5.5, Timer_DemoKaboom, GetClientSerial(owner), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	SDKUnhook(entity, SDKHook_Think, OnPipeBombThink);
}