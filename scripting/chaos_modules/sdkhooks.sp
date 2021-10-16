public Action OnTakeDamage(int client, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if(g_NoFall[client] && CheckValidClient(client) && damagetype & DMG_FALL && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		return Plugin_Handled;
	}
	if(g_GodMode[client] == 1 && CheckValidClient(client) && GetClientTeam(client) == TEAM_SURVIVOR)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action OnDemolitionMan(int entity)
{
	int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if(owner >= 1 && owner <= MaxClients && IsClientInGame(owner) && IsPlayerAlive(owner))
	{
		g_demoManActive[owner] = true;
		float vel[3];
		float pos[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
		GetEntPropVector(entity, Prop_Send, "m_vecVelocity", vel);
		
		SetEntPropFloat(entity, Prop_Data, "m_flDetonateTime", GetEngineTime() + 7.0);
		//This is horrible but will do for now :) vectors are confusing 
		int newPipe[18];
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
		
		for (int i = 1; i <= sizeof(newPipe) -1; i++)
		{
			CreateParticle(newPipe[i], 0);
			SetEntPropFloat(newPipe[i], Prop_Data, "m_flDetonateTime", GetEngineTime() + 7.0);
		}
		CreateTimer(5.5, Timer_DemoKaboom, _, TIMER_FLAG_NO_MAPCHANGE);
		g_demoManActive[owner] = false;
	}
	SDKUnhook(entity, SDKHook_Think, OnDemolitionMan);
}
public Action OnThrowYourself(int entity)
{
	int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if(owner >= 1 && owner <= MaxClients && IsClientInGame(owner) && IsPlayerAlive(owner))
	{
		PrintHintText(owner, "You rolled: Throw yourself!");
		float pipevel[3];
		float throwerpos[3];
			
		GetEntPropVector(entity, Prop_Send, "m_vecVelocity", pipevel);
		GetEntPropVector(owner, Prop_Send, "m_vecOrigin", throwerpos);

		pipevel[2] += 300.0;
		throwerpos[2] += 80.0;
		TeleportEntity(owner, NULL_VECTOR, NULL_VECTOR, pipevel);
		
		pipevel[0] = 0.0;
		pipevel[1] = 0.0;
		pipevel[2] = 0.0;
		TeleportEntity(entity, throwerpos, NULL_VECTOR, pipevel);
	}
	SDKUnhook(entity, SDKHook_Think, OnThrowYourself);
}

public Action OnPreThinkYeet(int client)
{
	if(GetEntityFlags(client) & FL_ONGROUND && g_NoFall[client])
	{
		g_NoFall[client] = false;
		PrintToServer("[CHAOS] Removed falling damage immunity from %N", client);
		SDKUnhook(client, SDKHook_PreThink, OnPreThinkYeet);
	}
}

public Action OnGrenadeTouch(int entity)
{
	if(g_randomCritActive)
	{
		UnSetCritGrenade();
		g_randomCritActive = false;
	}
}