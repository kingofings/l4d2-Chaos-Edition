static ConVar cvar;
static ConVar cvar_chainsawAmmo;

void Setup_Groovy()
{
    cvar = CreateChanceConVar("chaos_groovy", "0.10");
    cvar_chainsawAmmo = FindConVar("ammo_chainsaw_max");
}

void Roll_Groovy(int victim, int attacker, const char[] weapon)
{
    if(cvar.FloatValue == 1.0 || cvar.FloatValue > GetURandomFloat())
    {
        if (!StrEqual(weapon, "chainsaw", false) || GetClientTeam(victim) != TEAM_INFECTED || !IsPlayerAlive(attacker))return;
        
        int chainsaw = GetPlayerWeaponSlot(attacker, 1);
        if (!IsValidEntity(chainsaw))return;
        
        int maxAmmo = cvar_chainsawAmmo.IntValue;
        int clip = GetEntProp(chainsaw, Prop_Send, "m_iClip1");
        int refill = GetRandomInt(10, maxAmmo);
        if (clip + refill > maxAmmo)SetEntProp(chainsaw, Prop_Send, "m_iClip1", maxAmmo);
        else SetEntProp(chainsaw, Prop_Send, "m_iClip1", clip + refill);
            
        PrintHintText(attacker, "Groovy! Chainsaw fuel gained!");
    }
}