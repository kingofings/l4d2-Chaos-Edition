static Handle g_sdkCallOnRevive;

void Setup_SDKCalls(Handle hGameConf)
{
    StartPrepSDKCall(SDKCall_Player);
    PrepSDKCall_SetFromConf(hGameConf, SDKConf_Signature, "CTerrorPlayer::OnRevived()");
    g_sdkCallOnRevive = EndPrepSDKCall();
    if (!g_sdkCallOnRevive) SetFailState("Failed to Prepare SDKCall %s signature broken?", "CTerrorPlayer::OnRevived()");
}

void RevivePlayer(int client)
{
    SDKCall(g_sdkCallOnRevive, client);
}