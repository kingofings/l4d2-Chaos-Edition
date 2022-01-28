Action OnStartTouch(int client, int entity)
{
    if(IsPlayerMetalMario(client))
    {
        SDKHooks_TakeDamage(entity, client, client, 150.0, DMG_CLUB, _, NULL_VECTOR, NULL_VECTOR);
    }
}