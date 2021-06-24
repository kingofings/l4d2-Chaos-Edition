Handle g_GnomePickUpCookie = INVALID_HANDLE;
Handle H_StarManReapply = INVALID_HANDLE;
//float g_pos[3]; currently unused
#define PLUGIN_VERSION "1.0"

void CreateConVars()
{
	CreateConVar("sm_chaos_edition_version", PLUGIN_VERSION, "Standard plugin version ConVar. Please don't change me!", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	g_GnomePickUpCookie = RegClientCookie("gnome Cookie", "keeps track if player picked up the gnome before", CookieAccess_Private);
}