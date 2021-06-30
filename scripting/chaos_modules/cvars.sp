Handle g_GnomePickUpCookie = INVALID_HANDLE;
Handle H_StarManReapply = INVALID_HANDLE;
Handle g_CursedCookie = INVALID_HANDLE;
ConVar c_GrenadeLauncherDMG;
ConVar c_JockeyControlMax;
ConVar c_JockeyControlMin;
ConVar c_JockeyControlVar;
float g_JockeyControlMaxOld;
float g_JockeyControlMinOld;
float g_JockeyControlVarOld;

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
	c_JockeyControlMax = FindConVar("z_jockey_control_max");
	c_JockeyControlMin = FindConVar("z_jockey_control_min");
	c_JockeyControlVar = FindConVar("z_jockey_control_variance");
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
void L4D2_SetJockeyControlMax(float amount)
{
	 g_JockeyControlMaxOld = c_JockeyControlMax.FloatValue;
	 c_JockeyControlMax.FloatValue = amount;
}
void L4D2_RestoreJockeyControlMax()
{
	c_JockeyControlMax.FloatValue = g_JockeyControlMaxOld;
}
void L4D2_SetJockeyControlMin(float amount)
{
	g_JockeyControlMinOld = c_JockeyControlMin.FloatValue;
	c_JockeyControlMin.FloatValue = amount;
}
void L4D2_RestoreJockeyControlMin()
{
	c_JockeyControlMin.FloatValue = g_JockeyControlMinOld;
}
void L4D2_SetJockeyControlVar(float amount)
{
	g_JockeyControlVarOld = c_JockeyControlVar.FloatValue;
	c_JockeyControlVar.FloatValue = amount;
}
void L4D2_RestoreJockeyControlVar()
{
	c_JockeyControlVar.FloatValue = g_JockeyControlVarOld;
}