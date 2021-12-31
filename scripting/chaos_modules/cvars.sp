Handle H_StarManReapply = INVALID_HANDLE;
Handle g_sdkcallOnRevive;
Handle g_sdkcallExplodePipeBomb;

ConVar c_GrenadeLauncherDMG;
ConVar c_GrenadeTankDMG;
ConVar c_JockeyControlMax;
ConVar c_JockeyControlMin;
ConVar c_JockeyControlVar;
ConVar c_maxChainsawAmmo;
ConVar c_demoManChance;
ConVar c_throwYourSelfChance;
ConVar c_yeetChance;
ConVar g_metalMarioChance;
ConVar g_HealthRouletteChance;
ConVar g_eyeForEyeChance;
ConVar g_witchRevengeChance;
ConVar g_pillsHereChance;
ConVar g_starManGnomeChance;
ConVar g_heartAttackChance;
ConVar g_cursedChance;
ConVar g_jumpScareChance;
ConVar g_jumpScareSChance;
ConVar g_csgoAWPChance;
ConVar g_akJamChance;
ConVar g_noodleArms;
ConVar g_miracleChance;
ConVar g_unwantedVisitorChance;
ConVar g_karmaChance;
ConVar g_noJockeyResistanceChance;
ConVar g_randomCritChance;
ConVar g_tankRockChance;
ConVar g_movieLogicChance;
ConVar g_karmaChargerChance;
ConVar g_groovyChance;
ConVar g_suppressiveFireChance;
//ConVar g_wayOfSamuraiChance;

int g_oldGrenadeLauncherDamage;
int g_oldTankGrenadeDamage;
int g_TankRockAmbulanceEntity;
int g_TankRockCarEntity;

float g_JockeyControlMaxOld;
float g_JockeyControlMinOld;
float g_JockeyControlVarOld;

bool g_randomCritActive = false;
bool g_demoManActive[MAXPLAYERS + 1] = false;
bool g_NoFall[MAXPLAYERS + 1] = false;
bool g_Cursed[MAXPLAYERS + 1] = false;
bool g_GodMode[MAXPLAYERS + 1] = false;
bool g_GnomePickedUp[MAXPLAYERS + 1] = false;

#define PLUGIN_VERSION "1.0"
#define ZC_SMOKER 1
#define ZC_BOOMER 2
#define ZC_HUNTER 3
#define ZC_SPITTER 4
#define ZC_JOCKEY 5
#define ZC_CHARGER 6
#define ZC_WITCH 7
#define ZC_TANK 8
#define TEAM_SURVIVOR 2
#define TEAM_INFECTED 3
#define PARTICLE_FUSE						"weapon_pipebomb_fuse"
#define PARTICLE_LIGHT						"weapon_pipebomb_blinking_light"

void CreateConVars()
{
	AutoExecConfig_SetFile("chaos_edition");
	CreateConVar("sm_chaos_edition_version", PLUGIN_VERSION, "Standard plugin version ConVar. Please don't change me!", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	c_demoManChance = AutoExecConfig_CreateConVar("sm_chaos_demolition_man_chance", "0.20", "Chance is pecentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	c_throwYourSelfChance = AutoExecConfig_CreateConVar("sm_chaos_throw_yourself_chance", "0.20", "Chance is pecentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	c_yeetChance = AutoExecConfig_CreateConVar("sm_chaos_yeet_chance", "0.10", "Chance is pecentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_metalMarioChance = AutoExecConfig_CreateConVar("sm_chaos_metal_mario_chance", "0.10", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_HealthRouletteChance = AutoExecConfig_CreateConVar("sm_chaos_health_roulette_chance", "0.15", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_eyeForEyeChance = AutoExecConfig_CreateConVar("sm_chaos_eye_for_eye_chance", "0.20", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_witchRevengeChance = AutoExecConfig_CreateConVar("sm_chaos_witch_revenge_chance", "0.33", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_pillsHereChance = AutoExecConfig_CreateConVar("sm_chaos_pills_here_chance", "0.40", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_starManGnomeChance = AutoExecConfig_CreateConVar("sm_chaos_starman_gnome_chance", "0.04", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_heartAttackChance = AutoExecConfig_CreateConVar("sm_chaos_heart_attack_chance", "0.30", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cursedChance = AutoExecConfig_CreateConVar("sm_chaos_cursed_chance", "0.20", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_jumpScareChance = AutoExecConfig_CreateConVar("sm_chaos_jumpscare_chance", "0.25", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_jumpScareSChance = AutoExecConfig_CreateConVar("sm_chaos_jumpscare_saferoom_chance", "0.75", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_csgoAWPChance = AutoExecConfig_CreateConVar("sm_chaos_csgo_awp_chance", "0.02", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_akJamChance = AutoExecConfig_CreateConVar("sm_chaos_ak_jam_chance", "0.002", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_noodleArms = AutoExecConfig_CreateConVar("sm_chaos_noodle_arms_chance", "0.625", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_miracleChance = AutoExecConfig_CreateConVar("sm_chaos_micacle_chance", "0.01", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_unwantedVisitorChance = AutoExecConfig_CreateConVar("sm_chaos_unwanted_visitor_chance", "0.20", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_karmaChance = AutoExecConfig_CreateConVar("sm_chaos_karma_chance", "0.625", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_noJockeyResistanceChance = AutoExecConfig_CreateConVar("sm_chaos_no_jockey_resist_chance", "0.10", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_randomCritChance = AutoExecConfig_CreateConVar("sm_chaos_random_crit_chance", "0.12", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_tankRockChance = AutoExecConfig_CreateConVar("sm_chaos_tank_rock_chance", "0.50", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_movieLogicChance = AutoExecConfig_CreateConVar("sm_chaos_movie_logic_chance", "0.01", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_karmaChargerChance = AutoExecConfig_CreateConVar("sm_chaos_karma_charger_chance", "0.50", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_groovyChance = AutoExecConfig_CreateConVar("sm_chaos_groovy_chance", "0.10", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_suppressiveFireChance = AutoExecConfig_CreateConVar("sm_chaos_suppressive_fire_chance", "0.02", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	//g_wayOfSamuraiChance = AutoExecConfig_CreateConVar("sm_chaos_way_of_samurai_chance", "0.20", "Chance is percentage", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	c_GrenadeLauncherDMG = FindConVar("grenadelauncher_damage");
	c_GrenadeTankDMG = FindConVar("z_tank_grenade_damage");
	c_JockeyControlMax = FindConVar("z_jockey_control_max");
	c_JockeyControlMin = FindConVar("z_jockey_control_min");
	c_JockeyControlVar = FindConVar("z_jockey_control_variance");
	c_maxChainsawAmmo = FindConVar("ammo_chainsaw_max");
	AutoExecConfig_ExecuteFile();
}
void SetCritGrenade(int multiplier)
{
	g_oldTankGrenadeDamage = c_GrenadeTankDMG.IntValue;
	g_oldGrenadeLauncherDamage = c_GrenadeLauncherDMG.IntValue;
	c_GrenadeLauncherDMG.IntValue *= multiplier;
	c_GrenadeTankDMG.IntValue *= multiplier;
}
void UnSetCritGrenade()
{
	c_GrenadeTankDMG.IntValue = g_oldTankGrenadeDamage;
	c_GrenadeLauncherDMG.IntValue = g_oldGrenadeLauncherDamage;
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