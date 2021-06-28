Handle g_GnomePickUpCookie = INVALID_HANDLE;
Handle H_StarManReapply = INVALID_HANDLE;
Handle g_CursedCookie = INVALID_HANDLE;
ConVar c_GrenadeLauncherDMG;
#define PLUGIN_VERSION "1.0"
#define ZC_SMOKER 1
#define ZC_BOOMER 2
#define ZC_HUNTER 3
#define ZC_SPITTER 4
#define ZC_JOCKEY 5
#define ZC_CHARGER 6
#define ZC_WITCH 7
#define ZC_TANK 8

void CreateConVars()
{
	CreateConVar("sm_chaos_edition_version", PLUGIN_VERSION, "Standard plugin version ConVar. Please don't change me!", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	c_GrenadeLauncherDMG = FindConVar("grenadelauncher_damage");
	g_GnomePickUpCookie = RegClientCookie("gnome Cookie", "keeps track if player picked up the gnome before", CookieAccess_Private);
	g_CursedCookie = RegClientCookie("curse cookie", "if set players movement keys are inverted", CookieAccess_Private);
}
void SetCritGrenade(int damage)
{
	c_GrenadeLauncherDMG.IntValue = damage;
}
void UnSetCritGrenade(int damage)
{
	c_GrenadeLauncherDMG.IntValue = damage;
}