//============================================================================================================================================================================================================================================
//																								PLUGIN INFO
//============================================================================================================================================================================================================================================





/*=======================================================================================

	Plugin Info:

*	Name	:	RXMod
*	Author	:	Phil Bradley
*	Descrp	:	RXMod
*	Version :	1.0.1
*	Link	:	psbj.github.io

========================================================================================

	Change Log:

1.0.1 (14-Jan-2018)
	- RXMod source is no longer private
	- Crouch as charger to charge an uppercut
	- Crouch as spitter to charge for temporary invisibility and speed boost
	- Crouch as hunter to charge pounce damage
	- Crouch as recon to charge super jump
	- Become invisible and silent while not moving as hunter
	- Added teleport sound fx for smoker
	- Fixed infected select not working when you spawn as charger

1.0.0 (18-Feb-2016)
	- Initial release.

Talents
	Survivors
		- Protector
			Health:	300
			Speed:	80%
			25% more melee damage
			Slight increase in melee speed
			No fatigue from shoving

			Bind 1: Doubled movement speed for the next 15 seconds (Cooldown: 60 seconds)
			Bind 2: Invulnerable for the next 5 seconds (Cooldown: 60 seconds)

		- Commando
			Health:	100
			Speed:	110%
			Faster firing speed
			Faster reloading speed
			Extra 10% movement speed
			Weapons receive laser sights when picked up

			Bind 1: Spawn an ammo can at your feet
			Bind 2: Any infected you shoot will ignite and burn to death, lasts 30 seconds

		- Support
			Health:	200
			Speed:	100%
			Near-invisibility
			Extra 30% crouch speed
			Crouch to heal nearest teammate for 1 health, every 8 seconds, within 1536 units (96ft, 29m)
			Enables survivor crawling

			Bind 1: Drop three active pipebombs at your feet (Cooldown: 30 seconds)
			Bind 2: Spawn an M60

		- Medic
			Health:	100
			Speed:	100%
			1000% increase in magnum damage
			300% increase in pistol damage
			Gain 20 max health for every first aid kit used
			Crouch to heal teammates 1 health, every 5 seconds, within 256 units (16ft, 4.88m)
			Extra boost from pain pills and adrenaline
			After using a kit, you have a 50% chance to gain an extra health item

			Bind 1: Gamble for bonus supplies but not without risk!
			Bind 2: Open a menu to heal, revive, or ressurect teammates

		- Recon
			Health:	150
			Speed:	100%
			Extra 75% crouch speed

			Bind 1: Special infected will glow (ghost = white, spawned = red) for 30 seconds (Cooldown: 60 seconds)
			Bind 2: Invisible for the next 15 seconds (Cooldown: 60 seconds)

	Infected
		- Boomer
			Health:	50
			Speed:	100%
			Ability cooldown lowered to 10 seconds

			Bind 1: Increase movement speed and no cooldown on vomiting for 10 seconds (Cooldown: 30 seconds)
			Bind 2: Next time you jump, you will be launched into the air. Landing causes you to explode, flinging survivors (Cooldown: N/A)

		- Charger
			Health:	850
			Speed:	130%
			Pummel damage increased by 66%
			Punch damage increased by 30%
			Ability cooldown lowered to 7 seconds
			Can move tank-punchable objects by charging into them
			Can pick up incapped survivors as if they weren't incapped

			Bind 1: Double charge speed and distance (Cooldown: 30 seconds)
			Bind 2: Create an earthquake around you, knocking survivors down (Cooldown: 35 seconds)

		- Hunter
			Health:	500
			Speed:	180%
			Pounce distance increased by 50%
			Pounce damage increased by 42%
			Shredding damage increased by 40%
			Scratch damage increased by 40%

			Bind 1: Dismount from a survivor you have pounced on (Cooldown: 15 seconds)
			Bind 2: Poison a survivor, dealing 3 damage every second for 10 seconds (Cooldown: 15 seconds)

		- Jockey
			Health:	650
			Speed:	170%
			Ride speed increased by 30%
			Ride damage increased by 75%
			Scratch damage increased by 75%
			Ability cooldown lowered to 4 seconds
			Press JUMP while riding a survivor to jump in the air

			Bind 1: Urinate on the survivor you're riding (Cooldown: 45 seconds)
			Bind 2: Makes the jockey and survivor invisible for 10 seconds (Cooldown: 30 seconds)

		- Smoker
			Health:	250
			Speed:	120%
			Ability cooldown lowered to 6 seconds

			Bind 1: Teleport to your crosshair's position (within 300 ft) and become invisible for a few seconds (Cooldown: 10 seconds)
			Bind 2: Electrocute the survivor you're choking, doing 60 damage over 3 seconds, also doing 30 damage over 3 seconds to survivors within 50 ft (Cooldown: 40 seconds)

		- Spitter
			Health:	100
			Speed:	100%
			Ability cooldown lowered to 15 seconds

			Bind 1: Instantly reset your ability cooldown allowing you to spit an additional two times (Cooldown: 30 seconds)
			Bind 2: Spawn a witch at your crosshair, within 5 ft of your position (Cooldown: 5 minutes)

		- Tank
			Health:	10000
			Speed:	150%
			Punch interval decreased to 0.8 seconds
			Throw interval decreased to 3 seconds
			Will not lose control
			Press ZOOM to roar and knock back survivors

			Bind 1: N/A
			Bind 2: N/A

========================================================================================

	To Do:
	- [ ] Tank: crouch charge fire punch

======================================================================================*/





//============================================================================================================================================================================================================================================
//																								PLUGIN INCLUDES
//============================================================================================================================================================================================================================================





#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#pragma semicolon						1

#define PLUGIN_NAME 					"RXMod"
#define PLUGIN_AUTHOR 					"Phil Bradley"
#define PLUGIN_DESCRIPTION 				"Revamped XPM Mod"
#define PLUGIN_VERSION 					"1.0.1"
#define PLUGIN_URL	 					"steamcommunity.com/groups/rxmod"
#define PLUGIN_PREFIX 					"\x04[RXMod]\x01"
#define PLUGIN_COMMAND					"!rxm"

#define NAME_DATABASE					"rxmod"
#define NAME_GAMEDATA					"rxmod"

#define MAX_AUTH_LENGTH 				24
#define MAX_NAME_LENGTH					32
#define MAX_MSG_LENGTH 					128

#define SOUND_MENU_SELECT				"buttons/button14.wav"
#define SOUND_MENU_CONFIRM				"ui/beepclear.wav"
#define SOUND_MEDIC_AOE1				"ambient/energy/zap1.wav"
#define SOUND_MEDIC_AOE2				"ambient/energy/zap2.wav"
#define SOUND_MEDIC_AOE3				"ambient/energy/zap3.wav"
#define SOUND_SUPPORT_AOE1				"ambient/energy/zap1.wav"
#define SOUND_SUPPORT_AOE2				"ambient/energy/zap2.wav"
#define SOUND_SUPPORT_AOE3				"ambient/energy/zap3.wav"
#define SOUND_COMMANDO_FIRE				"weapons/molotov/fire_loop_1.wav"
#define SOUND_CHARGER_EARTHQUAKE		"ambient/explosions/explode_1.wav"
#define SOUND_JOCKEY_PEE				"ambient/spacial_loops/4b_hospatrium_waterleak.wav"
#define SOUND_JOCKEY_INVISIBILITY_YELL	"player/jockey/voice/idle/jockey_spotprey_01.wav"
#define SOUND_JOCKEY_JUMP				"player/jockey/voice/attack/jockey_loudattack01_wet.wav"
#define SOUND_SMOKER_TELEPORT			"player/smoker/death/smoker_explode_04.wav"
#define SOUND_SMOKER_TELEPORT_YELL		"player/smoker/voice/warn/smoker_warn_04.wav"
#define SOUND_SMOKER_ELECTRICITY		"ambient/energy/zap1.wav"
#define SOUND_TANK_ROAR					"player/tank/voice/yell/tank_yell_12.wav"

#define MODEL_AMMO_CAN					"models/props_unique/spawn_apartment/coffeeammo.mdl"
#define MODEL_NORMAL_WITCH				"models/infected/witch.mdl"
#define MODEL_HIDDEN_WITCH				"models/infected/common_female_tshirt_skirt.mdl"





//============================================================================================================================================================================================================================================
//																								GLOBAL VARIABLES
//============================================================================================================================================================================================================================================





new Handle:g_hEnable = INVALID_HANDLE;
new Handle:g_hTesting = INVALID_HANDLE;
new Handle:g_hFirstAidHealPercent = INVALID_HANDLE;
new Handle:g_hFirstAidKitMaxHeal = INVALID_HANDLE;
new Handle:g_hPainPillsHealthThreshold = INVALID_HANDLE;
new Handle:g_hZCommonLimit = INVALID_HANDLE;
new Handle:g_hZBoomerLimit = INVALID_HANDLE;
new Handle:g_hZChargerLimit = INVALID_HANDLE;
new Handle:g_hZHunterLimit = INVALID_HANDLE;
new Handle:g_hZJockeyLimit = INVALID_HANDLE;
new Handle:g_hZSmokerLimit = INVALID_HANDLE;
new Handle:g_hZSpitterLimit = INVALID_HANDLE;
new Handle:g_hAllowCrawling = INVALID_HANDLE;
new Handle:g_hCrawlSpeed = INVALID_HANDLE;
new Handle:g_hTDatabase = INVALID_HANDLE;
new Handle:g_hGameData = INVALID_HANDLE;
new Handle:g_hCTerrorPlayerFling = INVALID_HANDLE;
new Handle:g_hRoundRespawn = INVALID_HANDLE;
new Handle:g_hCreatePipe = INVALID_HANDLE;
new Handle:g_hPummelEnded = INVALID_HANDLE;
new Handle:g_hPounceEnd = INVALID_HANDLE;
new Handle:g_hStartActivationTimer = INVALID_HANDLE;
new Handle:g_hOnVomitedUpon = INVALID_HANDLE;
new Handle:g_hSetHumanSpec = INVALID_HANDLE;
new Handle:g_hTakeOverBot = INVALID_HANDLE;
new Handle:g_hOnStaggered = INVALID_HANDLE;
new Handle:g_hSetClass = INVALID_HANDLE;
new Handle:g_hCreateAbility = INVALID_HANDLE;

new Handle:g_hBindOneCooldown[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hBindTwoCooldown[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hBindWitchCooldown[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hJockeyJumpCooldown[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hTankRoarCooldown[MAXPLAYERS+1] = INVALID_HANDLE;

new Handle:g_hFireMode[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hPipeBomb[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hBoost[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hInvulnerability[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hInvisibility[MAXPLAYERS+1] = INVALID_HANDLE;

new Handle:g_hBoomerHotMeal[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hJockeyInvisibility[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hSmokerInvisibility[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hSmokerElectricity[MAXPLAYERS+1] = INVALID_HANDLE;

new String:g_sName[MAXPLAYERS+1][MAX_NAME_LENGTH];
new String:g_sAuth[MAXPLAYERS+1][MAX_AUTH_LENGTH];
new String:g_sIP[MAXPLAYERS+1][48];
new String:g_sLastServer[MAXPLAYERS+1][128];
new String:g_sSurvClass[MAXPLAYERS+1][48];
new String:g_sPrimary[MAXPLAYERS+1][48];
new String:g_sSecondary[MAXPLAYERS+1][48];
new String:g_sGrenade[MAXPLAYERS+1][48];
new String:g_sHealth[MAXPLAYERS+1][48];
new String:g_sBoost[MAXPLAYERS+1][48];
new String:g_sInfClassOne[MAXPLAYERS+1][48];
new String:g_sInfClassTwo[MAXPLAYERS+1][48];
new String:g_sInfClassThree[MAXPLAYERS+1][48];

new bool:g_bConfirmedSetup[MAXPLAYERS+1];
new bool:g_bBindOneActive[MAXPLAYERS+1];
new bool:g_bBindTwoActive[MAXPLAYERS+1];
new bool:g_bBindOneCooldown[MAXPLAYERS+1];
new bool:g_bBindTwoCooldown[MAXPLAYERS+1];
new bool:g_bBindWitchCooldown[MAXPLAYERS+1];
new bool:g_bJockeyJumpCooldown[MAXPLAYERS+1];
new bool:g_bJockeyInvisibility[MAXPLAYERS+1];
new bool:g_bTankRoarCooldown[MAXPLAYERS+1];
new bool:g_bInfectedSelectCooldown[MAXPLAYERS+1];
new bool:g_bStatsPanel[MAXPLAYERS+1];
new bool:g_bFireMode[MAXPLAYERS+1];
new bool:g_bBoost[MAXPLAYERS+1];
new bool:g_bInvulnerability[MAXPLAYERS+1];
new bool:g_bInvisibility[MAXPLAYERS+1];
new bool:g_bPreviousClient[MAXPLAYERS+1];
new bool:g_bInfectedGlow;
new bool:g_bSpawningWitch;

new Handle:g_hChargerUppercutCooldown[MAXPLAYERS+1];
new bool:g_bChargerUppercutCooldown[MAXPLAYERS+1];
new bool:g_bChargerUppercutActive[MAXPLAYERS+1];
new bool:g_bChargerUppercutCharging[MAXPLAYERS+1];
new g_iChargerUppercutCooldown[MAXPLAYERS+1];
new g_iChargerUppercutCharged[MAXPLAYERS+1];

new Handle:g_hReconJumpCooldown[MAXPLAYERS+1];
new bool:g_bReconJumpCooldown[MAXPLAYERS+1];
new bool:g_bReconJumpActive[MAXPLAYERS+1];
new bool:g_bReconJumpCharging[MAXPLAYERS+1];
new g_iReconJumpCooldown[MAXPLAYERS+1];
new g_iReconJumpCharged[MAXPLAYERS+1];

new Handle:g_hSpitterShiftCooldown[MAXPLAYERS+1];
new Handle:g_hSpitterShiftActive[MAXPLAYERS+1];
new bool:g_bSpitterShiftCooldown[MAXPLAYERS+1];
new bool:g_bSpitterShiftActive[MAXPLAYERS+1];
new bool:g_bSpitterShiftCharging[MAXPLAYERS+1];
new g_iSpitterShiftCooldown[MAXPLAYERS+1];
new g_iSpitterShiftCharged[MAXPLAYERS+1];

new Handle:g_hHunterPounceCooldown[MAXPLAYERS+1];
new Handle:g_hHunterPounceActive[MAXPLAYERS+1];
new bool:g_bHunterPounceCooldown[MAXPLAYERS+1];
new bool:g_bHunterPounceActive[MAXPLAYERS+1];
new bool:g_bHunterPounceCharging[MAXPLAYERS+1];
new g_iHunterPounceCooldown[MAXPLAYERS+1];
new g_iHunterPounceCharged[MAXPLAYERS+1];

new Handle:g_hHunterInvisibilityActive[MAXPLAYERS+1];
new Handle:g_hHunterVisibilityActive[MAXPLAYERS+1];
new bool:g_bHunterInvisibilityActive[MAXPLAYERS+1];
new g_iHunterInvisiblityTicks[MAXPLAYERS+1];
new g_iHunterVisiblityTicks[MAXPLAYERS+1];

new Float:g_fPosition[MAXPLAYERS+1][3];

new g_iLastConnected[MAXPLAYERS+1];
new g_iTimePlayed[MAXPLAYERS+1];

new g_iSurvivorCommonKills[MAXPLAYERS+1];
new g_iSurvivorSpecialKills[MAXPLAYERS+1];
new g_iSurvivorTankKills[MAXPLAYERS+1];
new g_iSurvivorWitchKills[MAXPLAYERS+1];
new g_iSurvivorSurvivorIncaps[MAXPLAYERS+1];
new g_iSurvivorSurvivorDeaths[MAXPLAYERS+1];
new g_iInfectedSurvivorDamage[MAXPLAYERS+1];
new g_iInfectedSurvivorKills[MAXPLAYERS+1];
new g_iInfectedSurvivorIncaps[MAXPLAYERS+1];
new g_iInfectedSpecialDeaths[MAXPLAYERS+1];

new g_iStaticHealth[MAXPLAYERS+1];
new g_iMaxHealth[MAXPLAYERS+1];
new g_iBindOneUses[MAXPLAYERS+1];
new g_iBindTwoUses[MAXPLAYERS+1];
new g_iBindOneCooldown[MAXPLAYERS+1];
new g_iBindTwoCooldown[MAXPLAYERS+1];
new g_iBindWitchCooldown[MAXPLAYERS+1];
new g_iJockeyJumpCooldown[MAXPLAYERS+1];
new g_iTankRoarCooldown[MAXPLAYERS+1];
new g_iPipeBombTicks[MAXPLAYERS+1];
new g_iHunterPoisonTicks[MAXPLAYERS+1];
new g_iSmokerInvisibilityTicks[MAXPLAYERS+1];
new g_iSmokerElectricityTicks[MAXPLAYERS+1];
new g_iSpitterSpitCount[MAXPLAYERS+1];
new g_iChargerVictim[MAXPLAYERS+1];
new g_iHunterVictim[MAXPLAYERS+1];
new g_iJockeyVictim[MAXPLAYERS+1];
new g_iSmokerVictim[MAXPLAYERS+1];

new g_iNextPAttO		= -1;
new g_iNextAttO			= -1;
new g_iActiveWO			= -1;
new g_iPlayRateO		= -1;
new g_iTimeIdleO		= -1;
new g_iVMStartTimeO		= -1;
new g_iViewModelO		= -1;

new g_iAbility = 0;
new g_iNextClass[MAXPLAYERS+1];





//============================================================================================================================================================================================================================================
//																								PUBLIC FUNCTIONS
//============================================================================================================================================================================================================================================





public Plugin:myinfo =
{
	name 			= PLUGIN_NAME,
	author 			= PLUGIN_AUTHOR,
	description 	= PLUGIN_DESCRIPTION,
	version 		= PLUGIN_VERSION,
	url 			= PLUGIN_URL
}

public OnPluginStart()
{
	CreateConVar("rxm_version", PLUGIN_VERSION, "Version of the installed plugin.", FCVAR_SPONLY|FCVAR_DONTRECORD|FCVAR_NOTIFY);

	g_hEnable 						= CreateConVar("rxm_enable", "1", "0 - Disable plugin, 1 - Enable plugin", _, true, 0.0, true, 1.0);
	g_hTesting 						= CreateConVar("rxm_testing", "0", "0 - Disable testing, 1 - Enable testing", _, true, 0.0, true, 1.0);

	g_hFirstAidHealPercent 			= FindConVar("first_aid_heal_percent");
	g_hFirstAidKitMaxHeal 			= FindConVar("first_aid_kit_max_heal");
	g_hPainPillsHealthThreshold 	= FindConVar("pain_pills_health_threshold");
	g_hZCommonLimit					= FindConVar("z_common_limit");
	g_hZBoomerLimit					= FindConVar("z_boomer_limit");
	g_hZChargerLimit				= FindConVar("z_charger_limit");
	g_hZHunterLimit					= FindConVar("z_hunter_limit");
	g_hZJockeyLimit					= FindConVar("z_jockey_limit");
	g_hZSmokerLimit					= FindConVar("z_smoker_limit");
	g_hZSpitterLimit				= FindConVar("z_spitter_limit");
	g_hAllowCrawling 				= FindConVar("survivor_allow_crawling");
	g_hCrawlSpeed					= FindConVar("survivor_crawl_speed");

	SQL_TConnect(OnSQLT_Connect, NAME_DATABASE);

	g_hGameData = LoadGameConfigFile(NAME_GAMEDATA);

	if (g_hGameData != INVALID_HANDLE)
	{
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CTerrorPlayer_Fling");
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		g_hCTerrorPlayerFling = EndPrepSDKCall();

		if (g_hCTerrorPlayerFling == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CTerrorPlayer_Fling", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "RoundRespawn");
		g_hRoundRespawn = EndPrepSDKCall();

		if (g_hRoundRespawn == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CTerrorPlayer_Fling", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Static);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CPipeBombProjectile_Create");
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
		g_hCreatePipe = EndPrepSDKCall();

		if (g_hCreatePipe == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CPipeBombProjectile_Create", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CTerrorPlayer::OnPummelEnded");
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer, VDECODE_FLAG_ALLOWNULL);
		g_hPummelEnded = EndPrepSDKCall();

		if (g_hPummelEnded == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CTerrorPlayer::OnPummelEnded", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CTerrorPlayer::OnPounceEnd");
		g_hPounceEnd = EndPrepSDKCall();

		if (g_hPounceEnd == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CTerrorPlayer::OnPounceEnd", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Entity);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CBaseAbility::StartActivationTimer");
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		g_hStartActivationTimer = EndPrepSDKCall();

		if (g_hStartActivationTimer == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CBaseAbility::StartActivationTimer", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Entity);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CTerrorPlayer_OnVomitedUpon");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		g_hOnVomitedUpon = EndPrepSDKCall();

		if (g_hOnVomitedUpon == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CTerrorPlayer_OnVomitedUpon", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "SetHumanSpec");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		g_hSetHumanSpec = EndPrepSDKCall();

		if (g_hSetHumanSpec == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: SetHumanSpec", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "TakeOverBot");
		PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
		g_hTakeOverBot = EndPrepSDKCall();

		if (g_hTakeOverBot == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: TakeOverBot", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CTerrorPlayer_OnStaggered");
		PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_Pointer);
		g_hOnStaggered = EndPrepSDKCall();

		if (g_hOnStaggered == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CTerrorPlayer_OnStaggered", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "SetClass");
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		g_hSetClass = EndPrepSDKCall();

		if (g_hSetClass == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: SetClass", PLUGIN_NAME);
		}

		StartPrepSDKCall(SDKCall_Static);
		PrepSDKCall_SetFromConf(g_hGameData, SDKConf_Signature, "CreateAbility");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
		g_hCreateAbility = EndPrepSDKCall();

		if (g_hCreateAbility == INVALID_HANDLE)
		{
			LogError("%s: Signature Broken: CreateAbility", PLUGIN_NAME);
		}

		g_iAbility = GameConfGetOffset(g_hGameData, "oAbility");
	}

	else
	{
		SetFailState("%s: Missing gamedata file!", PLUGIN_NAME);
	}

	g_iNextPAttO		= FindSendPropInfo("CBaseCombatWeapon", "m_flNextPrimaryAttack");
	g_iNextAttO			= FindSendPropInfo("CTerrorPlayer", "m_flNextAttack");
	g_iActiveWO			= FindSendPropInfo("CBaseCombatCharacter", "m_hActiveWeapon");
	g_iPlayRateO		= FindSendPropInfo("CBaseCombatWeapon", "m_flPlaybackRate");
	g_iTimeIdleO		= FindSendPropInfo("CTerrorGun", "m_flTimeWeaponIdle");
	g_iVMStartTimeO		= FindSendPropInfo("CTerrorViewModel", "m_flLayerStartTime");
	g_iViewModelO		= FindSendPropInfo("CTerrorPlayer", "m_hViewModel");

	RegConsoleCmd("sm_rxmod", Command_RXMod);
	RegConsoleCmd("rxmod", Command_RXMod);
	RegConsoleCmd("sm_rxm", Command_RXMod);
	RegConsoleCmd("rxm", Command_RXMod);
	RegConsoleCmd("sm_xpm", Command_RXMod);
	RegConsoleCmd("xpm", Command_RXMod);
	RegConsoleCmd("sm_rxmbind1", Command_BindOne);
	RegConsoleCmd("rxmbind1", Command_BindOne);
	RegConsoleCmd("sm_xpmbind1", Command_BindOne);
	RegConsoleCmd("xpmbind1", Command_BindOne);
	RegConsoleCmd("sm_rxmbind2", Command_BindTwo);
	RegConsoleCmd("rxmbind2", Command_BindTwo);
	RegConsoleCmd("sm_xpmbind2", Command_BindTwo);
	RegConsoleCmd("xpmbind2", Command_BindTwo);
	RegConsoleCmd("sm_rxmbinduses", Command_BindUses);
	RegConsoleCmd("rxmbinduses", Command_BindUses);
	RegConsoleCmd("sm_xpmbinduses", Command_BindUses);
	RegConsoleCmd("xpmbinduses", Command_BindUses);
	RegConsoleCmd("sm_tp", Command_ThirdPerson);
	RegConsoleCmd("sm_gm", Command_God);
	RegConsoleCmd("sm_nc", Command_NoClip);
	RegConsoleCmd("sm_cc", Command_Cheat);
	RegConsoleCmd("sm_sc", Command_Server);
	RegConsoleCmd("sm_rb", Command_RestoreBinds);

	HookConVarChange(g_hTesting, OnTestingToggled);

	HookEvent("player_disconnect", Event_PlayerDisconnect);
	HookEvent("player_changename", Event_PlayerChangeName);
	HookEvent("player_bot_replace", Event_PlayerBotReplace);
	HookEvent("bot_player_replace", Event_BotPlayerReplace);
	HookEvent("weapon_reload", Event_Reload);
	HookEvent("player_team", Event_Team);
	HookEvent("round_start_pre_entity", Event_RoundStart);
	HookEvent("heal_begin", Event_HealBegin);
	HookEvent("heal_success", Event_HealSuccess);
	HookEvent("pills_used", Event_PillsUsed);
	HookEvent("adrenaline_used", Event_AdrenalineUsed);
	HookEvent("item_pickup", Event_ItemPickup);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_incapacitated", Event_PlayerIncap);
	HookEvent("infected_death", Event_InfectedDeath);
	HookEvent("witch_killed", Event_WitchKilled);
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_jump_apex", Event_PlayerJumpApex/*, EventHookMode_Pre*/);
	HookEvent("ability_use", Event_AbilityUse);
	HookEvent("jockey_ride", Event_JockeyRide);
	HookEvent("jockey_ride_end", Event_JockeyRideEnd);
	HookEvent("tongue_grab", Event_TongueGrab);
	HookEvent("tongue_release", Event_TongueRelease);
	HookEvent("choke_start", Event_ChokeStart);
	HookEvent("choke_end", Event_ChokeEnd);
	HookEvent("charger_charge_start", Event_ChargerChargeStart);
	HookEvent("charger_charge_end", Event_ChargerChargeEnd);
	HookEvent("witch_spawn", Event_WitchSpawn);
	HookEvent("witch_harasser_set", Event_WitchHarasserSet);
	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("infected_hurt", Event_InfectedHurt);
	HookEvent("player_left_start_area", Event_LeftStartArea);
	HookEvent("pounce_end", Event_PounceEnd);
	HookEvent("lunge_pounce", Event_PounceLunge);

	AddNormalSoundHook(NormalSHook);

	AddCommandListener(Listener_Say,"say");
	AddCommandListener(Listener_Say,"say_team");

	CreateTimer(1.0, Timer_Positions, _, TIMER_REPEAT);
	CreateTimer(5.0, Timer_MedicCrouch, _, TIMER_REPEAT);
	CreateTimer(8.0, Timer_SupportCrouch, _, TIMER_REPEAT);
}

public OnConfigsExecuted()
{
	SetConVarFloat(g_hFirstAidHealPercent, 1.0);
	SetConVarInt(g_hFirstAidKitMaxHeal, 1000);
	SetConVarInt(g_hPainPillsHealthThreshold, 1000);
	SetConVarInt(g_hZBoomerLimit, 1);
	SetConVarInt(g_hZChargerLimit, 1);
	SetConVarInt(g_hZHunterLimit, 1);
	SetConVarInt(g_hZJockeyLimit, 1);
	SetConVarInt(g_hZSmokerLimit, 1);
	SetConVarInt(g_hZSpitterLimit, 1);
}

public OnClientAuthorized(client, const String:auth[])
{
	if (!IsFakeClient(client))
	{
		GetClientName(client, g_sName[client], sizeof(g_sName[]));
		strcopy(g_sAuth[client], sizeof(g_sAuth[]), auth);
		GetClientIP(client, g_sIP[client], sizeof(g_sIP[]));

		if (g_hTDatabase != INVALID_HANDLE)
		{
			new String:sQuery[512];
			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_info WHERE client_auth='%s'", auth);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_AuthorizedClientInfo, sQuery, client);

			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_stats WHERE client_auth='%s'", auth);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_AuthorizedClientStats, sQuery, client);

			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_survivor WHERE client_auth='%s'", auth);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_AuthorizedClientSurvivor, sQuery, client);

			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_infected WHERE client_auth='%s'", auth);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_AuthorizedClientInfected, sQuery, client);
		}
	}
}

public OnClientPostAdminCheck(client)
{
	if (client == 0)
	{
		return;
	}

	if (IsFakeClient(client))
	{
		return;
	}

	if (!g_bPreviousClient[client])
	{
		for (new x = 1; x <= MaxClients; x++)
		{
			if (IsClientInGame(x) && !IsFakeClient(x) && client != x)
			{
				PrintToChat(x, "%s %s has connected!", PLUGIN_PREFIX, g_sName[client]);
			}
		}

		ResetGlobals(client);
		KillTimers(client);

		PrintToChat(client, "%s Welcome to \x04%s\x01 (v%s)!", PLUGIN_PREFIX, PLUGIN_NAME, PLUGIN_VERSION);
		PrintToChat(client, "%s To begin playing, type \x04%s\x01 in chat!", PLUGIN_PREFIX, PLUGIN_COMMAND);

		g_bPreviousClient[client] = true;
	}

	if (g_hTDatabase == INVALID_HANDLE)
	{
		PrintToChat(client, "%s Plugin is in \x04OFFLINE MODE\x01 while database unavailable!", PLUGIN_PREFIX);
	}
}

public OnClientDisconnect(client)
{
	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client))
	{
		ResetGlobals(client);
		KillTimers(client);

		if (g_hTDatabase != INVALID_HANDLE)
		{
			new String:sQuery[512];
			Format(sQuery, sizeof(sQuery), "UPDATE client_survivor SET client_class='%s', client_primary='%s', client_secondary='%s', client_grenade='%s', client_health='%s', client_boost='%s' WHERE client_auth='%s'", g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
			Format(sQuery, sizeof(sQuery), "UPDATE client_infected SET client_class_1='%s', client_class_2='%s', client_class_3='%s' WHERE client_auth='%s'", g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client], g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
		}
	}
}

public OnMapStart()
{
	PrecacheModel(MODEL_AMMO_CAN);
	PrecacheModel(MODEL_HIDDEN_WITCH);
	PrecacheModel(MODEL_NORMAL_WITCH);
	PrecacheSound(SOUND_JOCKEY_PEE);
	PrecacheSound(SOUND_JOCKEY_JUMP);
	PrecacheSound(SOUND_COMMANDO_FIRE);
	PrecacheSound(SOUND_MEDIC_AOE1);
	PrecacheSound(SOUND_MEDIC_AOE2);
	PrecacheSound(SOUND_MEDIC_AOE3);
	PrecacheSound(SOUND_SUPPORT_AOE1);
	PrecacheSound(SOUND_SUPPORT_AOE2);
	PrecacheSound(SOUND_SUPPORT_AOE3);
	PrecacheSound(SOUND_MENU_SELECT);
	PrecacheSound(SOUND_MENU_CONFIRM);
	PrecacheSound(SOUND_CHARGER_EARTHQUAKE);
	PrecacheSound(SOUND_JOCKEY_INVISIBILITY_YELL);
	PrecacheSound(SOUND_SMOKER_TELEPORT);
	PrecacheSound(SOUND_SMOKER_TELEPORT_YELL);
	PrecacheSound(SOUND_SMOKER_ELECTRICITY);
	PrecacheSound(SOUND_TANK_ROAR);
	g_bSpawningWitch = false;

	if (g_hTDatabase == INVALID_HANDLE)
	{
		SQL_TConnect(OnSQLT_Connect, NAME_DATABASE);
	}

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && !IsFakeClient(x))
		{
			ResetGlobals(x);
			KillTimers(x);
		}
	}
}

public OnMapEnd()
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && !IsFakeClient(x))
		{
			ResetGlobals(x);
			KillTimers(x);
		}
	}
}

public OnTestingToggled(Handle:hConVar, const String:oldValue[], const String:newValue[])
{
	switch(GetConVarBool(g_hTesting))
	{
		case 0:
		{
			ResetConVar(g_hZCommonLimit);
			SetConVarInt(g_hZBoomerLimit, 1);
			SetConVarInt(g_hZChargerLimit, 1);
			SetConVarInt(g_hZHunterLimit, 1);
			SetConVarInt(g_hZJockeyLimit, 1);
			SetConVarInt(g_hZSmokerLimit, 1);
			SetConVarInt(g_hZSpitterLimit, 1);
		}

		case 1:
		{
			SetConVarInt(g_hZCommonLimit, 0);
			SetConVarInt(g_hZBoomerLimit, 0);
			SetConVarInt(g_hZChargerLimit, 0);
			SetConVarInt(g_hZHunterLimit, 0);
			SetConVarInt(g_hZJockeyLimit, 0);
			SetConVarInt(g_hZSmokerLimit, 0);
			SetConVarInt(g_hZSpitterLimit, 0);
		}
	}
}

public OnGameFrame()
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && !IsFakeClient(x))
		{
			if (IsPlayerInfected(x))
			{
				if (IsPlayerHunter(x) && IsClassHunter(x) && !IsPlayerGhost(x) && IsPlayerConfirmed(x))
				{
					if (IsPlayerPouncing(x))
					{
						if (GetEntityGravity(x) != 0.45)
						{
							SetEntityGravity(x, 0.45);
						}

						if (GetEntPropFloat(x, Prop_Send, "m_flLaggedMovementValue") != 3.0)
						{
							SetEntPropFloat(x, Prop_Send, "m_flLaggedMovementValue", 3.0);
						}
					}

					else
					{
						SetEntityGravity(x, 1.0);
						SetEntPropFloat(x, Prop_Send, "m_flLaggedMovementValue", 2.0);
					}
				}

				if (IsPlayerJockey(x) && IsClassJockey(x) && !IsPlayerGhost(x) && IsPlayerConfirmed(x))
				{
					if (!IsPlayerGrounded(x))
					{
						SetEntityGravity(x, 0.9);
					}

					else
					{
						SetEntityGravity(x, 1.0);
					}
				}
			}

			if (IsPlayerSurvivor(x))
			{
				if (IsClassSupport(x) && IsPlayerConfirmed(x))
				{
					if (GetClientButtons(x) & IN_DUCK && IsPlayerGrounded(x) && !IsPlayerIncapped(x))
					{
						SetEntPropFloat(x, Prop_Send, "m_flLaggedMovementValue", 1.3);
					}

					else
					{
						SetEntPropFloat(x, Prop_Send, "m_flLaggedMovementValue", 1.0);
					}
				}

				if (IsClassRecon(x) && IsPlayerConfirmed(x))
				{
					if (GetClientButtons(x) & IN_DUCK && IsPlayerGrounded(x) && !IsPlayerIncapped(x))
					{
						SetEntPropFloat(x, Prop_Send, "m_flLaggedMovementValue", 1.75);
					}

					else
					{
						SetEntPropFloat(x, Prop_Send, "m_flLaggedMovementValue", 1.0);
					}
				}
			}
		}
	}
}





//============================================================================================================================================================================================================================================
//																								SDKHOOK CALLBACKS
//============================================================================================================================================================================================================================================





/*
DMG_GENERIC = 0
DMG_CRUSH = 1
DMG_BULLET = 2
DMG_SLASH = 4
DMG_BURN = 8
DMG_VEHICLE = 16
DMG_FALL = 32
DMG_BLAST = 64
DMG_CLUB = 128
DMG_SHOCK = 256
DMG_SONIC = 512
DMG_ENERGYBEAM = 1024
DMG_PREVENT_PHYSICS_FORCE = 2048
DMG_NEVERGIB = 4096
DMG_ALWAYSGIB = 8192
DMG_DROWN = 16384
DMG_PARALYZE = 32768
DMG_NERVEGAS = 65536
DMG_POISON = 131072
DMG_RADIATION = 262144
DMG_DROWNRECOVER = 524288
DMG_ACID = 1048576
DMG_SLOWBURN = 2097152
DMG_REMOVENORAGDOLL = 4194304
DMG_PHYSGUN = 8388608
DMG_PLASMA = 16777216
DMG_AIRBOAT = 33554432
DMG_DISSOLVE = 67108864
DMG_BLAST_SURFACE = 134217728
DMG_DIRECT = 268435456
DMG_BUCKSHOT = 536870912

CHARGER:

Claw:

[EI] player_hurt
[EI] userid: "6"
[EI] attacker: "2"
[EI] attackerentid: "1"
[EI] health: "87"
[EI] armor: "0"
[EI] weapon: "charger_claw"
[EI] dmg_health: "13"
[EI] dmg_armor: "0"
[EI] hitgroup: "0"
[EI] type: "128"





SMOKER:

Claw:

[EI] player_hurt_concise
[EI] userid: "6"
[EI] attackerentid: "1"
[EI] type: "128"
[EI] dmg_health: "4"

Pulling:

[EI] player_hurt_concise
[EI] userid: "4"
[EI] attackerentid: "1"
[EI] type: "1048576"
[EI] dmg_health: "3"

Choking:

[EI] player_hurt_concise
[EI] userid: "4"
[EI] attackerentid: "1"
[EI] type: "1048576"
[EI] dmg_health: "5"






SPITTER:

Claw:

[EI] player_hurt_concise
[EI] userid: "14"
[EI] attackerentid: "1"
[EI] type: "128"
[EI] dmg_health: "4"

Spit:

DMG_RADIATION + DMG_ENERGYBEAM

[EI] player_hurt_concise
[EI] userid: "15"
[EI] attackerentid: "1"
[EI] type: "263168"
[EI] dmg_health: "4"

[EI] player_hurt_concise
[EI] userid: "15"
[EI] attackerentid: "1"
[EI] type: "265216"
[EI] dmg_health: "3"






BOOMER:

Claw:

[EI] player_hurt_concise
[EI] userid: "24"
[EI] attackerentid: "1"
[EI] type: "128"
[EI] dmg_health: "4"
*/

public Action:Hook_OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if (IsClientInGame(victim))
	{
		if ((IsPlayerSurvivor(victim) && IsClassCommando(victim) && IsPlayerConfirmed(victim)) || (IsPlayerInfected(victim) && IsPlayerTank(victim) && IsPlayerConfirmed(victim)))
		{
			if (damagetype == 8 || damagetype == 2056 || damagetype == 268435464)
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}

		if (IsPlayerSurvivor(victim) && IsClassRecon(victim) && IsPlayerConfirmed(victim))
		{
			if (damagetype & DMG_FALL)
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
	}

	if (victim <= 0 || attacker <= 0 || victim > MaxClients || attacker > MaxClients)
	//if (victim <= 0 || victim > MaxClients || attacker > MaxClients)
	{
		return Plugin_Continue;
	}

	if (IsClientInGame(victim) && IsClientInGame(attacker) && damage > 0.0)
	{
		/*PrintToChatAll("Victim: %d", victim);
		PrintToChatAll("Attacker: %d", attacker);
		PrintToChatAll("Inflictor: %d", inflictor);
		PrintToChatAll("Damage: %f", damage);
		PrintToChatAll("DamageType: %d", damagetype);*/

		if (IsPlayerSurvivor(victim) && IsPlayerInfected(attacker) && !IsFakeClient(attacker) && IsPlayerConfirmed(attacker))
		{
			if (IsPlayerCharger(attacker))
			{
				if (damagetype & DMG_CLUB)
				{
					if (damage == 15.0)
					{
						damage += 10.0;
					}

					else if (damage == 10.0)
					{
						damage += 3.0;

						if (g_bChargerUppercutActive[attacker] && !IsPlayerPinned(victim) && !IsPlayerIncapped(victim))
						{
							Uppercut(attacker, victim);
							g_bChargerUppercutActive[attacker] = false;
							g_bChargerUppercutCooldown[attacker] = true;
							g_iChargerUppercutCooldown[attacker] = GetTime() + 10;
							g_hChargerUppercutCooldown[attacker] = CreateTimer(10.0, Timer_ChargerUppercutCooldown, attacker);
						}
					}
				}
			}

			if (IsPlayerHunter(attacker))
			{
				if (damagetype & DMG_CRUSH)
				{
					if (damage == 12.0)
					{
						damage += 5.0;
					}

				}
				if (damagetype & DMG_CLUB)
				{
					if (damage == 5.0)
					{
						damage += 2.0;
					}

					else if (damage == 15.0)
					{
						damage += 4.0;
					}
				}
			}

			if (IsPlayerJockey(attacker))
			{
				if (damagetype & DMG_CLUB)
				{
					if (damage == 4.0)
					{
						damage += 3.0;
					}

				}
			}

			g_iInfectedSurvivorDamage[attacker] += RoundToZero(damage);
		}

		if (IsPlayerInfected(victim) && IsPlayerSurvivor(attacker) && !IsFakeClient(attacker))
		{
			new String:sWeapon[32];
			GetClientWeapon(attacker, sWeapon, sizeof(sWeapon));

			if (IsClassProtector(attacker) && IsPlayerConfirmed(attacker))
			{
				if (StrEqual(sWeapon, "weapon_melee") && (damagetype & DMG_CRUSH || damagetype & DMG_SLASH || damagetype & DMG_CLUB))
				{
					damage = FloatMul(damage, 1.25);
					PrintToChatAll("Melee Damage: %f", damage);
				}
			}

			if (IsClassMedic(attacker) && IsPlayerConfirmed(attacker))
			{
				if (StrEqual(sWeapon, "weapon_pistol_magnum") && damagetype & DMG_BULLET)
				{
					damage = FloatMul(damage, 6.0);
					PrintToChatAll("Magnum Damage: %f", damage);
				}

				if (StrEqual(sWeapon, "weapon_pistol") && damagetype & DMG_BULLET)
				{
					damage = FloatMul(damage, 3.0);
					PrintToChatAll("Pistol Damage: %f", damage);
				}
			}
		}
	}

	return Plugin_Changed;
}

public Action:Hook_PostThinkPost(client)
{
	if (IsClientInGame(client) && !IsFakeClient(client) && IsClassRecon(client) && g_bBindTwoActive[client])
	{
		SetEntProp(client, Prop_Send, "m_iAddonBits", 0);
	}

	if (IsClientInGame(client) && IsPlayerSurvivor(client) && g_bJockeyInvisibility[client])
	{
		SetEntProp(client, Prop_Send, "m_iAddonBits", 0);
		StopGlow(client);
	}

	return Plugin_Changed;
}

public Action:Hook_StartTouch(entity, other)
{
	if (IsClientInGame(entity) && IsPlayerBoomer(entity) && IsPlayerGrounded(entity) && g_bBindTwoActive[entity])
	{
		ForcePlayerSuicide(entity);

		new Float:entityPos[3];
		GetClientAbsOrigin(entity, entityPos);

		for (new x = 1; x <= MaxClients; x++)
		{
			if (IsClientInGame(x) && IsPlayerSurvivor(x))
			{
				new Float:xPos[3];
				GetClientAbsOrigin(x, xPos);

				if (GetVectorDistance(entityPos, xPos) <= 384 && InLineOfSight(entity, x))
				{
					if (!IsPlayerPinned(x))
					{
						decl Float:HeadingVector[3], Float:AimVector[3];

						GetClientEyeAngles(entity, HeadingVector);
						AimVector[0] = FloatMul( Cosine( DegToRad(HeadingVector[1])  ) , 400.0);
						AimVector[1] = FloatMul( Sine( DegToRad(HeadingVector[1])  ) , 400.0);

						decl Float:current[3];
						GetEntPropVector(x, Prop_Data, "m_vecVelocity", current);

						decl Float:resulting[3];
						resulting[0] = FloatAdd(current[0], AimVector[0]);
						resulting[1] = FloatAdd(current[1], AimVector[1]);
						resulting[2] = 600.0;

						SDKCall(g_hCTerrorPlayerFling, x, resulting, 76, entity, 5);
					}

					ApplyDamage(entity, x, 20);
					Vomit(entity, x);
				}
			}
		}

		g_bBindTwoActive[entity] = false;
		SDKUnhook(entity, SDKHook_StartTouch, Hook_StartTouch);
	}
}

public Action:Hook_SetTransmit(client, entity)
{
	// new Float:fDistance = GetVectorDistance(g_fPosition[client], g_fPosition[entity]);

	if (client == entity || IsPlayerInfected(entity) /* || fDistance <= 512*/)
	{
		return Plugin_Continue;
	}

	return Plugin_Handled;
}





//============================================================================================================================================================================================================================================
//																								COMMAND CALLBACKS
//============================================================================================================================================================================================================================================





public Action:Command_RXMod(client, args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	DisplayMainPanel(client);

	return Plugin_Handled;
}

public Action:Command_BindOne(client, args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (IsPlayerSpectator(client))
	{
		PrintToChat(client, "%s You cannot use binds while spectating!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (!IsPlayerAlive(client))
	{
		PrintToChat(client, "%s You cannot use binds while dead!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (IsPlayerGhost(client))
	{
		PrintToChat(client, "%s You cannot use binds while a ghost!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (!IsPlayerConfirmed(client))
	{
		PrintToChat(client, "%s Confirm your setup before using binds!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (g_iBindOneUses[client] <= 0 && !IsPlayerHunter(client) && !IsPlayerSmoker(client))
	{
		PrintToChat(client, "%s You are out of bind 1 uses!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (g_bBindOneCooldown[client])
	{
		new iRawTime = g_iBindOneCooldown[client] - GetTime();
		new iHours = (iRawTime / 3600);
		new iMinutes = ((iRawTime % 3600) / 60);
		new iSeconds = ((iRawTime % 3600) % 60);
		new String:sCooldownTime[256];
		if (g_iBindOneCooldown[client] > 0)
		{
			if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
			else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
			else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
		}

		PrintHintText(client, "You must wait %s before using that bind!", sCooldownTime);
		return Plugin_Handled;
	}

	if (IsPlayerSurvivor(client))
	{
		if (IsClassProtector(client))
		{
			if (g_bBoost[client])
			{
				PrintHintText(client, "Boost is already active!");
				return Plugin_Handled;
			}

			g_bBoost[client] = true;
			g_iBindOneUses[client]--;
			g_bBindOneCooldown[client] = true;
			g_iBindOneCooldown[client] = GetTime() + 60;

			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", FloatMul(GetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue"), 2.0));

			PrintHintText(client, "Your movement speed is doubled for the next 15 seconds!");
			g_hBoost[client] = CreateTimer(15.0, Timer_Boost, client);
			g_hBindOneCooldown[client] = CreateTimer(60.0, Timer_BindOneCooldown, client);
			return Plugin_Handled;
		}

		else if (IsClassCommando(client))
		{
			if (IsPlayerGrounded(client))
			{
				g_iBindOneUses[client]--;

				new Float:clientPos[3];
				GetClientAbsOrigin(client, clientPos);
				new Float:clientAng[3];
				GetClientAbsAngles(client, clientAng);

				new entity = CreateEntityByName("weapon_ammo_spawn");

				DispatchSpawn(entity);
				SetEntityModel(entity, MODEL_AMMO_CAN);
				TeleportEntity(entity, clientPos, clientAng, NULL_VECTOR);
				return Plugin_Handled;
			}

			else
			{
				PrintToChat(client, "%s You must be on the ground to deploy ammo!", PLUGIN_PREFIX);
				return Plugin_Handled;
			}
		}

		else if (IsClassSupport(client))
		{
			g_iBindOneUses[client]--;
			g_bBindOneCooldown[client] = true;
			g_iBindOneCooldown[client] = GetTime() + 30;

			g_hBindOneCooldown[client] = CreateTimer(30.0, Timer_BindOneCooldown, client);
			CreateTimer(1.0, Timer_PipeBomb, client);
			return Plugin_Handled;
		}

		else if (IsClassMedic(client))
		{
			g_iBindOneUses[client]--;
			MedicGamble(client);
			return Plugin_Handled;
		}

		else if (IsClassRecon(client))
		{
			if (g_bInfectedGlow)
			{
				PrintHintText(client, "Infected glow is already active!");
				return Plugin_Handled;
			}

			g_bInfectedGlow = true;
			g_iBindOneUses[client]--;
			g_iBindOneCooldown[client] = GetTime() + 60;

			for (new x = 1; x <= MaxClients; x++)
			{
				if (IsClientInGame(x) && IsPlayerInfected(x) && IsPlayerAlive(x))
				{
					StartGlow(x);
				}
			}

			PrintHintText(client, "Special infected will glow for the next 30 seconds!");
			g_hBindOneCooldown[client] = CreateTimer(60.0, Timer_BindOneCooldown, client);
			CreateTimer(30.0, Timer_InfectedGlow, client);
			return Plugin_Handled;
		}
	}

	if (IsPlayerInfected(client))
	{
		if (IsPlayerBoomer(client) && IsClassBoomer(client))
		{
			if (g_bBindOneActive[client])
			{
				PrintHintText(client, "Your first bind is already active!");
				return Plugin_Handled;
			}

			g_iBindOneUses[client]--;
			g_bBindOneActive[client] = true;
			g_bBindOneCooldown[client] = true;
			g_iBindOneCooldown[client] = GetTime() + 38;
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 2.0);
			SetConVarInt(FindConVar("z_vomit_interval"), 1);
			ResetAbility(client, 0.0);
			g_hBoomerHotMeal[client] = CreateTimer(8.0, Timer_BoomerHotMeal, client);
			g_hBindOneCooldown[client] = CreateTimer(38.0, Timer_BindOneCooldown, client);
			return Plugin_Handled;
		}

		else if (IsPlayerCharger(client) && IsClassCharger(client))
		{
			//SDKCall(g_hPummelEnded, client, true, -1);
			//PrintHintText(client, "You have let go of the survivor!");

			if (g_bBindOneActive[client])
			{
				PrintHintText(client, "Your first bind is already active!");
				return Plugin_Handled;
			}

			g_bBindOneActive[client] = true;
			g_bBindOneCooldown[client] = true;
			g_iBindOneCooldown[client] = GetTime() + 30;
			ResetAbility(client, 0.0);
			g_hBindOneCooldown[client] = CreateTimer(30.0, Timer_BindOneCooldown, client);
			return Plugin_Handled;
		}

		else if (IsPlayerHunter(client) && IsClassHunter(client))
		{
			g_bBindOneCooldown[client] = true;
			g_iBindOneCooldown[client] = GetTime() + 15;
			SDKCall(g_hPounceEnd, client);
			PrintHintText(client, "You have dismounted!");
			g_hBindOneCooldown[client] = CreateTimer(15.0, Timer_BindOneCooldown, client);
			return Plugin_Handled;
		}

		else if (IsPlayerJockey(client) && IsClassJockey(client))
		{
			if (g_iJockeyVictim[client] > 0)
			{
				g_bBindOneCooldown[client] = true;
				g_iBindOneCooldown[client] = GetTime() + 45;
				EmitSoundToAll(SOUND_JOCKEY_PEE, g_iJockeyVictim[client]);
				EmitSoundToAll(SOUND_JOCKEY_PEE, g_iJockeyVictim[client]);
				EmitSoundToAll(SOUND_JOCKEY_PEE, g_iJockeyVictim[client]);
				EmitSoundToAll(SOUND_JOCKEY_PEE, g_iJockeyVictim[client]);
				Vomit(client, g_iJockeyVictim[client]);
				CreateTimer(5.0, Timer_JockeyPeeSound, g_iJockeyVictim[client]);
				g_hBindOneCooldown[client] = CreateTimer(45.0, Timer_BindOneCooldown, client);

				g_iBindOneUses[client]--;
			}

			else
			{
				PrintHintText(client, "You must be riding a survivor!");
			}

			return Plugin_Handled;
		}

		else if (IsPlayerSmoker(client) && IsClassSmoker(client))
		{
			new Float:vOrigin[3];
			new Float:vAim[3];
			GetClientAbsOrigin(client, vOrigin);
			GetClientAimPosition(client, vAim);

			if (GetVectorDistance(vOrigin, vAim) <= 2400)
			{
				g_bBindOneCooldown[client] = true;
				g_iBindOneCooldown[client] = GetTime() + 10;
				vAim[2]+=10.0;
				TeleportEntity(client, vAim, NULL_VECTOR, NULL_VECTOR);
				SetEntityRenderMode(client, RENDER_TRANSCOLOR);
				SetEntityRenderColor(client, 255, 255, 255, 0);
				EmitSoundToAll(SOUND_SMOKER_TELEPORT, client);
				EmitSoundToAll(SOUND_SMOKER_TELEPORT_YELL, client);
				g_hSmokerInvisibility[client] = CreateTimer(0.001, Timer_SmokerInvisibility, client);
				g_hBindOneCooldown[client] = CreateTimer(10.0, Timer_BindOneCooldown, client);
			}

			else
			{
				PrintHintText(client, "You cannot teleport beyond 300 ft!");
			}

			return Plugin_Handled;
		}

		else if (IsPlayerSpitter(client) && IsClassSpitter(client))
		{
			if (g_bBindOneActive[client])
			{
				PrintHintText(client, "Your first bind is already active!");
				return Plugin_Handled;
			}

			g_iBindOneUses[client]--;
			g_bBindOneActive[client] = true;
			SetConVarInt(FindConVar("z_spit_interval"), 0);
			ResetAbility(client, 0.0);
			return Plugin_Handled;
		}
	}

	return Plugin_Handled;
}

public Action:Command_BindTwo(client, args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (IsPlayerSpectator(client))
	{
		PrintToChat(client, "%s You cannot use binds while spectating!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (!IsPlayerAlive(client))
	{
		PrintToChat(client, "%s You cannot use binds while dead!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (IsPlayerGhost(client))
	{
		PrintToChat(client, "%s You cannot use binds while a ghost!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (!IsPlayerConfirmed(client))
	{
		PrintToChat(client, "%s Confirm your setup before using binds!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (g_iBindTwoUses[client] <= 0)
	{
		PrintToChat(client, "%s You are out of bind 2 uses!", PLUGIN_PREFIX);
		return Plugin_Handled;
	}

	if (g_bBindTwoCooldown[client])
	{
		new iRawTime = g_iBindTwoCooldown[client] - GetTime();
		new iHours = (iRawTime / 3600);
		new iMinutes = ((iRawTime % 3600) / 60);
		new iSeconds = ((iRawTime % 3600) % 60);
		new String:sCooldownTime[256];
		if (g_iBindTwoCooldown[client] > 0)
		{
			if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
			else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
			else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
		}

		PrintHintText(client, "You must wait %s before using that bind!", sCooldownTime);
		return Plugin_Handled;
	}

	if (IsPlayerSurvivor(client))
	{
		if (IsClassProtector(client))
		{

			if (g_bInvulnerability[client])
			{
				PrintHintText(client, "Invulnerability is already active!");
				return Plugin_Handled;
			}

			g_bInvulnerability[client] = true;
			g_iBindTwoUses[client]--;
			g_bBindTwoCooldown[client] = true;
			g_iBindTwoCooldown[client] = GetTime() + 60;

			SetEntProp(client, Prop_Data, "m_takedamage", 0);
			PrintHintText(client, "You are now invulnerable for the next 5 seconds!");
			g_hInvulnerability[client] = CreateTimer(5.0, Timer_Invulnerability, client);
			g_hBindTwoCooldown[client] = CreateTimer(60.0, Timer_BindTwoCooldown, client);
			return Plugin_Handled;
		}

		else if (IsClassCommando(client))
		{
			if (g_bFireMode[client])
			{
				PrintHintText(client, "Fire mode is already active!");
				return Plugin_Handled;
			}

			g_bFireMode[client] = true;
			g_iBindTwoUses[client]--;

			EmitSoundToAll(SOUND_COMMANDO_FIRE, client);
			PrintHintText(client, "You are now in fire mode for the next 30 seconds!");
			g_hFireMode[client] = CreateTimer(30.0, Timer_FireMode, client);
			return Plugin_Handled;
		}

		else if (IsClassSupport(client))
		{
			g_iBindTwoUses[client]--;

			new flags = GetCommandFlags("give");
			SetCommandFlags("give", flags & ~FCVAR_CHEAT);
			FakeClientCommand(client, "give rifle_m60");
			SetCommandFlags("give", flags|FCVAR_CHEAT);
			flags = GetCommandFlags("upgrade_add");
			SetCommandFlags("upgrade_add", flags & ~FCVAR_CHEAT);
			FakeClientCommand(client, "upgrade_add LASER_SIGHT");
			SetCommandFlags("upgrade_add", flags|FCVAR_CHEAT);
			return Plugin_Handled;
		}

		else if (IsClassMedic(client))
		{
			DisplayMedicPanel(client);
			return Plugin_Handled;
		}

		else if (IsClassRecon(client))
		{

			if (g_bInvisibility[client])
			{
				PrintHintText(client, "Invisibility is already active!");
				return Plugin_Handled;
			}

			g_bInvisibility[client] = true;
			g_iBindTwoUses[client]--;
			g_bBindTwoCooldown[client] = true;
			g_iBindTwoCooldown[client] = GetTime() + 60;

			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.75);
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 64, 64, 255, 0);
			new weapon_entity = GetPlayerWeaponSlot(client, 0);
			SetEntityRenderMode(weapon_entity, RENDER_TRANSCOLOR);
			SetEntityRenderColor(weapon_entity, 0, 0, 0, 0);
			PrintHintText(client, "You are now invisible for the next 15 seconds!");
			g_hInvisibility[client] = CreateTimer(15.0, Timer_Invisibility, client);
			g_hBindTwoCooldown[client] = CreateTimer(60.0, Timer_BindTwoCooldown, client);
			return Plugin_Handled;
		}
	}

	if (IsPlayerInfected(client))
	{
		if (IsPlayerBoomer(client) && IsClassBoomer(client))
		{
			if (g_bBindTwoActive[client])
			{
				PrintHintText(client, "Your second bind is already active!");
				return Plugin_Handled;
			}

			g_bBindTwoActive[client] = true;
			return Plugin_Handled;
		}

		else if (IsPlayerCharger(client) && IsClassCharger(client))
		{
			if (g_bBindTwoActive[client])
			{
				PrintHintText(client, "Your second bind is already active!");
				return Plugin_Handled;
			}

			g_bBindTwoActive[client] = true;
			return Plugin_Handled;
		}

		else if (IsPlayerHunter(client) && IsClassHunter(client))
		{
			if (g_bBindTwoActive[client])
			{
				PrintHintText(client, "Your second bind is already active!");
				return Plugin_Handled;
			}

			g_bBindTwoActive[client] = true;
			return Plugin_Handled;
		}

		else if (IsPlayerJockey(client) && IsClassJockey(client))
		{
			if (g_iJockeyVictim[client] > 0)
			{
				EmitSoundToAll(SOUND_JOCKEY_INVISIBILITY_YELL, client);
				EmitSoundToAll(SOUND_JOCKEY_INVISIBILITY_YELL, client);
				g_bBindTwoCooldown[client] = true;
				g_iBindTwoCooldown[client] = GetTime() + 40;
				g_bJockeyInvisibility[g_iJockeyVictim[client]] = true;
				SetEntityRenderColor(client, 255, 255, 255, 26);
				SetEntityRenderColor(g_iJockeyVictim[client], 255, 255, 255, 26);
				SDKHook(client, SDKHook_SetTransmit, Hook_SetTransmit);
				SDKHook(g_iJockeyVictim[client], SDKHook_SetTransmit, Hook_SetTransmit);
				g_hJockeyInvisibility[client] = CreateTimer(10.0, Timer_JockeyInvisibility, client);
				g_hJockeyInvisibility[g_iJockeyVictim[client]] = CreateTimer(10.0, Timer_JockeyInvisibility, g_iJockeyVictim[client]);
				g_hBindTwoCooldown[client] = CreateTimer(40.0, Timer_BindTwoCooldown, client);
				StopGlow(g_iJockeyVictim[client]);
				StopGlow(client);

				g_iBindTwoUses[client]--;
			}

			else
			{
				PrintHintText(client, "You must be riding a survivor!");
			}

			return Plugin_Handled;
		}

		else if (IsPlayerSmoker(client) && IsClassSmoker(client))
		{
			if (g_iSmokerVictim[client] > 0)
			{
				g_iBindTwoUses[client]--;
				g_bBindTwoCooldown[client] = true;
				g_iBindTwoCooldown[client] = GetTime() + 40;

				g_hSmokerElectricity[client] = CreateTimer(0.5, Timer_SmokerElectricity, client);
				g_hBindTwoCooldown[client] = CreateTimer(40.0, Timer_BindTwoCooldown, client);
			}

			else
			{
				PrintHintText(client, "You must be choking a survivor!");
			}

			return Plugin_Handled;
		}

		else if (IsPlayerSpitter(client) && IsClassSpitter(client))
		{
			if (g_bBindWitchCooldown[client])
			{
				new iRawTime = g_iBindWitchCooldown[client] - GetTime();
				new iHours = (iRawTime / 3600);
				new iMinutes = ((iRawTime % 3600) / 60);
				new iSeconds = ((iRawTime % 3600) % 60);
				new String:sCooldownTime[256];
				if (g_iBindWitchCooldown[client] > 0)
				{
					if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
					else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
					else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
				}

				PrintHintText(client, "You must wait %s before using that bind!", sCooldownTime);
				return Plugin_Handled;
			}

			new Float:vOrigin[3];
			new Float:vAim[3];
			GetClientAbsOrigin(client, vOrigin);
			GetClientAimPosition(client, vAim);

			if (GetVectorDistance(vOrigin, vAim) <= 80)
			{
				g_iBindTwoUses[client]--;
				g_bBindWitchCooldown[client] = true;
				g_iBindWitchCooldown[client] = GetTime() + 300;
				g_bSpawningWitch = true;

				new flags = GetCommandFlags("z_spawn");
				SetCommandFlags("z_spawn", flags & ~FCVAR_CHEAT);
				FakeClientCommand(client, "z_spawn witch");
				SetCommandFlags("z_spawn", flags|FCVAR_CHEAT);

				g_hBindWitchCooldown[client] = CreateTimer(300.0, Timer_BindWitchCooldown, client);
			}

			else
			{
				PrintHintText(client, "You can only spawn a witch within 5 ft!");
			}

			return Plugin_Handled;
		}
	}

	return Plugin_Handled;
}

public Action:Command_BindUses(client, args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	PrintToChat(client, "%s Bind 1: %d uses remain", PLUGIN_PREFIX, g_iBindOneUses[client]);
	PrintToChat(client, "%s Bind 2: %d uses remain", PLUGIN_PREFIX, g_iBindTwoUses[client]);

	return Plugin_Handled;
}

public Action:Command_ThirdPerson(client, args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (GetConVarBool(g_hEnable) && IsClientAuthor(client) && IsPlayerAlive(client))
	{
		if (GetEntPropFloat(client, Prop_Send, "m_TimeForceExternalView") == 99999.3)
		{
			SetEntPropFloat(client, Prop_Send, "m_TimeForceExternalView", 0.0);
		}

		else
		{
			SetEntPropFloat(client, Prop_Send, "m_TimeForceExternalView", 99999.3);
		}
	}

	return Plugin_Handled;
}

public Action:Command_God(client, args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (GetConVarBool(g_hEnable) && IsClientAuthor(client) && IsPlayerAlive(client))
	{
		if (GetEntProp(client, Prop_Data, "m_takedamage") > 0)
		{
			SetEntProp(client, Prop_Data, "m_takedamage", 0);
			PrintHintText(client, "God mode enabled!");
			return Plugin_Handled;
		}

		else
		{
			SetEntProp(client, Prop_Data, "m_takedamage", 2);
			PrintHintText(client, "God mode disabled!");
			return Plugin_Handled;
		}
	}

	return Plugin_Handled;
}

public Action:Command_NoClip(client,args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (GetConVarBool(g_hEnable) && IsClientAuthor(client) && IsPlayerAlive(client))
	{
		if (GetEntityMoveType(client) == MOVETYPE_WALK)
		{
			SetEntityMoveType(client, MOVETYPE_NOCLIP);
			PrintHintText(client, "NoClip enabled!");
			return Plugin_Handled;
		}

		else
		{
			SetEntityMoveType(client, MOVETYPE_WALK);
			PrintHintText(client, "NoClip disabled!");
			return Plugin_Handled;
		}
	}

	return Plugin_Handled;
}

public Action:Command_Cheat(client,args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (GetConVarBool(g_hEnable) && IsClientAuthor(client))
	{
		if (GetCmdArgs() > 0)
		{
			new String:arg1[256];
			GetCmdArg(1, arg1, sizeof(arg1));
			new String:argstring[256];
			GetCmdArgString(argstring, sizeof(argstring));

			new flags = GetCommandFlags(arg1);
			SetCommandFlags(arg1, flags & ~FCVAR_CHEAT);
			FakeClientCommand(client, argstring);
			SetCommandFlags(arg1, flags|FCVAR_CHEAT);

			PrintHintText(client, "Cheat: %s", argstring);
			return Plugin_Handled;
		}

		return Plugin_Handled;
	}

	return Plugin_Handled;
}

public Action:Command_Server(client,args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (GetConVarBool(g_hEnable) && IsClientAuthor(client))
	{
		if (GetCmdArgs() > 0)
		{
			new String:arg1[256];
			GetCmdArg(1, arg1, sizeof(arg1));
			new String:argstring[256];
			GetCmdArgString(argstring, sizeof(argstring));

			ServerCommand(argstring);

			PrintHintText(client, "Console: %s", argstring);
			return Plugin_Handled;
		}

		return Plugin_Handled;
	}

	return Plugin_Handled;
}

public Action:Command_RestoreBinds(client,args)
{
	if (client == 0)
	{
		PrintToServer("[%s] This command can only be used in-game!", PLUGIN_NAME);
		return Plugin_Handled;
	}

	if (GetConVarBool(g_hEnable) && IsClientAuthor(client))
	{
		g_bBindOneCooldown[client] = false;
		g_bBindTwoCooldown[client] = false;
		g_bBindWitchCooldown[client] = false;
		g_bJockeyJumpCooldown[client] = false;
		g_bTankRoarCooldown[client] = false;
		g_iBindOneCooldown[client] = 0;
		g_iBindTwoCooldown[client] = 0;
		g_iBindWitchCooldown[client] = 0;
		g_iJockeyJumpCooldown[client] = 0;
		g_iTankRoarCooldown[client] = 0;
		g_iBindOneUses[client] = 3;
		g_iBindTwoUses[client] = 3;
		if (g_hBindOneCooldown[client] != INVALID_HANDLE) { KillTimer(g_hBindOneCooldown[client]); g_hBindOneCooldown[client] = INVALID_HANDLE; }
		if (g_hBindTwoCooldown[client] != INVALID_HANDLE) { KillTimer(g_hBindTwoCooldown[client]); g_hBindTwoCooldown[client] = INVALID_HANDLE; }
		if (g_hBindWitchCooldown[client] != INVALID_HANDLE) { KillTimer(g_hBindWitchCooldown[client]); g_hBindWitchCooldown[client] = INVALID_HANDLE; }
		if (g_hJockeyJumpCooldown[client] != INVALID_HANDLE) { KillTimer(g_hJockeyJumpCooldown[client]); g_hJockeyJumpCooldown[client] = INVALID_HANDLE; }
		if (g_hTankRoarCooldown[client] != INVALID_HANDLE) { KillTimer(g_hTankRoarCooldown[client]); g_hTankRoarCooldown[client] = INVALID_HANDLE; }
		PrintHintText(client, "Binds restored!");
	}

	return Plugin_Handled;
}





//============================================================================================================================================================================================================================================
//																								EVENT CALLBACKS
//============================================================================================================================================================================================================================================





public Event_PlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	if (!IsFakeClient(client))
	{
		g_iTimePlayed[client] += RoundToZero(GetClientTime(client));

		if (g_hTDatabase != INVALID_HANDLE)
		{
			new String:sQuery[512];
			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_info WHERE client_auth='%s'", g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_DisconnectClientInfo, sQuery, client);

			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_stats WHERE client_auth='%s'", g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_DisconnectClientStats, sQuery, client);
		}

		g_bPreviousClient[client] = false;
	}
}

public Event_PlayerChangeName(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	new String:cname[MAX_NAME_LENGTH];
	GetEventString(event, "newname", cname, sizeof(cname));

	if (!IsFakeClient(client))
	{
		strcopy(g_sName[client], sizeof(g_sName[]), cname);

		if (g_hTDatabase != INVALID_HANDLE)
		{
			new String:sQuery[512];
			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_info WHERE client_auth='%s'", g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_ChangeNameClientInfo, sQuery, client);

			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_stats WHERE client_auth='%s'", g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_ChangeNameClientStats, sQuery, client);

			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_survivor WHERE client_auth='%s'", g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_ChangeNameClientSurvivor, sQuery, client);

			Format(sQuery, sizeof(sQuery), "SELECT * FROM client_infected WHERE client_auth='%s'", g_sAuth[client]);
			SQL_TQuery(g_hTDatabase, OnSQLTQuery_ChangeNameClientInfected, sQuery, client);
		}
	}
}

//Bot replaced a player
public Event_PlayerBotReplace(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "player"));
	new bot = GetClientOfUserId(GetEventInt(event, "bot"));

	if (IsClientInGame(client) && IsClientInGame(bot))
	{
		ResetColor(bot);
		ResetSpeed(bot);
		ResetHealth(client, bot);
		ResetCvars(bot);
	}
}

//Player replaced a bot
public Event_BotPlayerReplace(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "player"));
	new bot = GetClientOfUserId(GetEventInt(event, "bot"));

	if (IsClientInGame(client) && IsClientInGame(bot))
	{
		ApplyColor(client);
		ApplySpeed(client);
		ApplyHealth(client, bot);
		ApplyCvars(client);

	}
}

public Event_Reload(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (IsPlayerConfirmed(client) && IsClassCommando(client))
	{
		new iEntid = GetEntDataEnt2(client, g_iActiveWO);
		if (!IsValidEntity(iEntid)) return;

		new Float:flRate = 0.25;
		new Float:flGameTime = GetGameTime();
		new Float:flNextTime_ret = GetEntDataFloat(iEntid, g_iNextPAttO);
		new Float:flNextTime_calc = ( flNextTime_ret - flGameTime ) * flRate ;

		SetEntDataFloat(iEntid, g_iPlayRateO, 1.0/flRate, true);

		//experiment to remove double-playback bug
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, client);
		//this calculates the equivalent time for the reload to end
		//if the survivor didn't have the SoH perk
		new Float:flStartTime_calc = flGameTime - ( flNextTime_ret - flGameTime ) * ( 1 - flRate ) ;
		WritePackFloat(hPack, flStartTime_calc);
		//now we create the timer that will prevent the annoying double playback
		if ( (flNextTime_calc - 0.4) > 0 )
		{
			CreateTimer( flNextTime_calc - 0.4 , SoH_MagEnd2, hPack);
		}

		flNextTime_calc += flGameTime;
		SetEntDataFloat(iEntid, g_iTimeIdleO, flNextTime_calc, true);
		SetEntDataFloat(iEntid, g_iNextPAttO, flNextTime_calc, true);
		SetEntDataFloat(client, g_iNextAttO, flNextTime_calc, true);
	}
}

public Event_Team(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	g_bBindOneActive[client] = false;
	g_bBindTwoActive[client] = false;
	g_bBindOneCooldown[client] = false;
	g_bBindTwoCooldown[client] = false;
	g_bJockeyJumpCooldown[client] = false;
	g_bJockeyInvisibility[client] = false;
	g_bTankRoarCooldown[client] = false;
	g_bInfectedSelectCooldown[client] = false;
	g_iChargerVictim[client] = 0;
	g_iHunterVictim[client] = 0;
	g_iJockeyVictim[client] = 0;
	g_iSmokerVictim[client] = 0;
	g_iNextClass[client] = 0;

	if (IsPlayerSmoker(client) && IsClassSmoker(client))
	{
		ResetCvars(client);
	}

	return;
}


public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && !IsFakeClient(x))
		{
			ResetGlobals(x);
			KillTimers(x);
		}
	}
}

public Event_HealBegin(Handle:event, const String:name[], bool:dontBroadcast)
{
	new target = GetClientOfUserId(GetEventInt(event, "subject"));

	g_iStaticHealth[target] = GetClientHealth(target);
	g_iMaxHealth[target] = GetEntProp(target, Prop_Data, "m_iMaxHealth");
}

public Event_HealSuccess(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new target = GetClientOfUserId(GetEventInt(event, "subject"));

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && !IsFakeClient(x) && IsClassMedic(x) && IsPlayerConfirmed(x))
		{
			if (client != x)
			{
				if (target == x)
				{
					new iMaxHealth = GetEntProp(x, Prop_Data, "m_iMaxHealth");
					new iHealth = GetClientHealth(x);
					SetEntProp(x, Prop_Data, "m_iMaxHealth", iMaxHealth + 20);
					SetEntityHealth(x, iHealth + 120);
				}

				else
				{
					new iMaxHealth = GetEntProp(x, Prop_Data, "m_iMaxHealth");
					new iHealth = GetClientHealth(x);
					SetEntProp(x, Prop_Data, "m_iMaxHealth", iMaxHealth + 20);
					SetEntityHealth(x, iHealth + 20);
				}
			}

			if (client == x)
			{
				new iChance = GetRandomInt(0, 100);

				if (iChance >= 52 && iChance <= 63)
				{
					new flags = GetCommandFlags("give");
					SetCommandFlags("give", flags & ~FCVAR_CHEAT);
					FakeClientCommand(client, "give first_aid_kit");
					SetCommandFlags("give", flags|FCVAR_CHEAT);
					PrintHintText(client, "You found an extra first aid kit!");
				}

				if (iChance >= 64 && iChance <= 75)
				{
					new flags = GetCommandFlags("give");
					SetCommandFlags("give", flags & ~FCVAR_CHEAT);
					FakeClientCommand(client, "give defibrillator");
					SetCommandFlags("give", flags|FCVAR_CHEAT);
					PrintHintText(client, "You found an extra defibrillator!");
				}

				if (iChance >= 76 && iChance <= 87)
				{
					new flags = GetCommandFlags("give");
					SetCommandFlags("give", flags & ~FCVAR_CHEAT);
					FakeClientCommand(client, "give pain_pills");
					SetCommandFlags("give", flags|FCVAR_CHEAT);
					PrintHintText(client, "You found an extra set of pills!");
				}

				if (iChance >= 88 && iChance <= 100)
				{
					new flags = GetCommandFlags("give");
					SetCommandFlags("give", flags & ~FCVAR_CHEAT);
					FakeClientCommand(client, "give adrenaline");
					SetCommandFlags("give", flags|FCVAR_CHEAT);
					PrintHintText(client, "You found an extra adrenaline syringe!");
				}
			}
		}

		else if (IsClientInGame(x) && IsPlayerSurvivor(x) && target == x)
		{
			if (g_iStaticHealth[x] + 100 > g_iMaxHealth[x])
			{
				SetEntityHealth(x, g_iMaxHealth[x]);
			}

			else
			{
				SetEntityHealth(x, g_iStaticHealth[x] + 100);
			}
		}
	}
}

public Event_PillsUsed(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "subject"));

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && IsClassMedic(x) && IsPlayerConfirmed(x))
		{
			if (client == x)
			{
				new Float:fTempHealth = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
				SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
				SetEntPropFloat(client, Prop_Send, "m_healthBuffer", fTempHealth + 25.0);
			}

			else
			{
				new Float:fTempHealth = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
				SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
				SetEntPropFloat(client, Prop_Send, "m_healthBuffer", fTempHealth + 10.0);
			}
		}
	}
}

public Event_AdrenalineUsed(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && IsClassMedic(x) && IsPlayerConfirmed(x))
		{
			if (client == x)
			{
				new Float:fTempHealth = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
				SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
				SetEntPropFloat(client, Prop_Send, "m_healthBuffer", fTempHealth + 15.0);
			}

			else
			{
				new Float:fTempHealth = GetEntPropFloat(client, Prop_Send, "m_healthBuffer");
				SetEntPropFloat(client, Prop_Send, "m_healthBufferTime", GetGameTime());
				SetEntPropFloat(client, Prop_Send, "m_healthBuffer", fTempHealth + 5.0);
			}
		}
	}
}

public Event_ItemPickup(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new String:item[64];
	GetEventString(event, "item", item, sizeof(item));

	if (StrEqual(item, "smg") || StrEqual(item, "smg_silenced") || StrEqual(item, "smg_mp5") || StrEqual(item, "rifle") || StrEqual(item, "rifle_sg552") || StrEqual(item, "rifle_ak47") || StrEqual(item, "autoshotgun") || StrEqual(item, "shotgun_spas") || StrEqual(item, "rifle_m60") || StrEqual(item, "sniper_awp") || StrEqual(item, "sniper_military") || StrEqual(item, "sniper_scout") || StrEqual(item, "hunting_rifle") || StrEqual(item, "pumpshotgun") || StrEqual(item, "shotgun_chrome"))
	{
		for (new x = 1; x <= MaxClients; x++)
		{
			if (IsClientInGame(x) && !IsFakeClient(x) && IsPlayerSurvivor(x) && IsClassCommando(x) && IsPlayerConfirmed(x))
			{
				new flags = GetCommandFlags("upgrade_add");
				SetCommandFlags("upgrade_add", flags & ~FCVAR_CHEAT);
				FakeClientCommand(client, "upgrade_add LASER_SIGHT");
				SetCommandFlags("upgrade_add", flags|FCVAR_CHEAT);
				return;
			}
		}
	}

	if (StrEqual(item, "boomer_claw") || StrEqual(item, "charger_claw") || StrEqual(item, "hunter_claw") || StrEqual(item, "jockey_claw") || StrEqual(item, "smoker_claw") || StrEqual(item, "spitter_claw"))
	{
		if (g_bInfectedGlow)
		{
			StartGlow(client);
		}
	}
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client))
	{
		SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);
		SDKHook(client, SDKHook_PostThinkPost, Hook_PostThinkPost);

		if (IsPlayerInfected(client) && IsPlayerConfirmed(client))
		{
			ApplyColor(client);
			ApplySpeed(client);
			ApplyHealth(client, client);
			ApplyCvars(client);
		}

		else if (IsPlayerInfected(client) && IsFakeClient(client))
		{
			ResetColor(client);
			ResetSpeed(client);
			ResetHealth(client, client);
			ResetCvars(client);
		}

		if (IsPlayerInfected(client) && g_bInfectedGlow)
		{
			StartGlow(client);
		}
	}

	// if (IsClientInGame(client) && IsFakeClient(client))
	// {
	// 	ResetColor(client);
	// 	ResetHealth(client);
	// 	ResetSpeed(client);
	// 	ResetCvars(client);
	// }

	// if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerSurvivor(client) && IsPlayerConfirmed(client))
	// {
	// 	ApplyColor(client);
	// 	ApplyHealth(client);
	// 	ApplySpeed(client);
	// 	ApplyCvars(client);
	// }

	// if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerConfirmed(client))
	// {
	// 	ApplyColor(client);
	// 	ApplyHealth(client);
	// 	ApplySpeed(client);
	// 	ApplyCvars(client);
	// }

	// if (IsClientInGame(client) && IsPlayerInfected(client) && g_bInfectedGlow)
	// {
	// 	StartGlow(client);
	// }

	// if (IsClientInGame(client))
	// {
	// 	SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);
	// 	SDKHook(client, SDKHook_PostThinkPost, Hook_PostThinkPost);
	// }
}

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	if (client == 0)
	{
		return;
	}

	g_bBindOneActive[client] = false;
	g_bBindTwoActive[client] = false;
	g_bBindOneCooldown[client] = false;
	g_bBindTwoCooldown[client] = false;
	g_bJockeyJumpCooldown[client] = false;
	g_bJockeyInvisibility[client] = false;
	g_bTankRoarCooldown[client] = false;
	g_bInfectedSelectCooldown[client] = false;
	g_iChargerVictim[client] = 0;
	g_iHunterVictim[client] = 0;
	g_iJockeyVictim[client] = 0;
	g_iSmokerVictim[client] = 0;

	g_bChargerUppercutCooldown[client] = false;
	g_bChargerUppercutActive[client] = false;
	g_bChargerUppercutCharging[client] = false;
	g_iChargerUppercutCooldown[client] = 0;
	g_iChargerUppercutCharged[client] = 0;

	g_bReconJumpCooldown[client] = false;
	g_bReconJumpActive[client] = false;
	g_bReconJumpCharging[client] = false;
	g_iReconJumpCooldown[client] = 0;
	g_iReconJumpCharged[client] = 0;

	g_bSpitterShiftCooldown[client] = false;
	g_bSpitterShiftActive[client] = false;
	g_bSpitterShiftCharging[client] = false;
	g_iSpitterShiftCooldown[client] = 0;
	g_iSpitterShiftCharged[client] = 0;

	g_bHunterPounceCooldown[client] = false;
	g_bHunterPounceActive[client] = false;
	g_bHunterPounceCharging[client] = false;
	g_iHunterPounceCooldown[client] = 0;
	g_iHunterPounceCharged[client] = 0;

	g_bHunterInvisibilityActive[client] = false;
	g_iHunterInvisiblityTicks[client] = 0;
	g_iHunterVisiblityTicks[client] = 0;

	KillTimers(client);

	if (IsClientInGame(client) && IsPlayerInfected(client))
	{
		if (!IsPlayerGhost(client))
		{
			StopGlow(client);
		}

		if (!IsFakeClient(client))
		{
			ResetCvars(client);
		}
	}

	if (IsClientInGame(client))
	{
		if (IsPlayerSurvivor(client))
		{
			if (!IsFakeClient(client))
			{
				g_iSurvivorSurvivorDeaths[client]++;
				StopSound(client, SNDCHAN_AUTO, SOUND_COMMANDO_FIRE);
				StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
				StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
				StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
				StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
			}

			if (attacker > 0)
			{
				if (!IsFakeClient(attacker) && IsPlayerInfected(attacker))
				{
					g_iInfectedSurvivorKills[attacker]++;
				}
			}
		}

		if (IsPlayerInfected(client) && !IsPlayerTank(client))
		{
			if (!IsFakeClient(client))
			{
				g_iInfectedSpecialDeaths[client]++;
			}

			if (attacker > 0)
			{
				if (!IsFakeClient(attacker) && IsPlayerSurvivor(attacker))
				{
					g_iSurvivorSpecialKills[attacker]++;
				}
			}
		}

		if (IsPlayerInfected(client) && IsPlayerTank(client))
		{
			if (!IsFakeClient(client))
			{
				g_iInfectedSpecialDeaths[client]++;
			}

			if (attacker > 0)
			{
				if (!IsFakeClient(attacker) && IsPlayerSurvivor(attacker))
				{
					g_iSurvivorTankKills[attacker]++;
				}
			}
		}
	}
}

public Event_PlayerIncap(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client))
	{
		if (IsPlayerSurvivor(client))
		{
			if (!IsFakeClient(client))
			{
				g_iSurvivorSurvivorIncaps[client]++;
			}

			if (attacker > 0)
			{
				if (!IsFakeClient(attacker) && IsPlayerInfected(attacker))
				{
					g_iInfectedSurvivorIncaps[attacker]++;
				}
			}
		}
	}
}

public Event_InfectedDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "attacker"));

	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client))
	{
		if (IsPlayerSurvivor(client))
		{
			g_iSurvivorCommonKills[client]++;
		}
	}
}

public Event_WitchKilled(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client))
	{
		if (IsPlayerSurvivor(client))
		{
			g_iSurvivorWitchKills[client]++;
		}
	}
}

public Event_PlayerJumpApex(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	if (IsPlayerBoomer(client) && IsClassBoomer(client))
	{
		if (g_bBindTwoActive[client])
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 2.0);
		}
	}
}

public Event_AbilityUse(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new String:ability[24];
	GetEventString(event, "ability", ability, sizeof(ability));

	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		if (StrEqual(ability, "ability_spit"))
		{
			//PrintToChatAll("DEBUG: Spit Used");

			if (g_bBindOneActive[client])
			{
				//PrintToChatAll("DEBUG: Bind Active");
				if (g_iSpitterSpitCount[client] < 2)
				{
					g_iSpitterSpitCount[client]++;
					//PrintToChatAll("DEBUG: Spit Increased: %d", g_iSpitterSpitCount[client]);
				}

				else
				{
					//PrintToChatAll("DEBUG: Spit Finished: %d", g_iSpitterSpitCount[client]);
					g_iSpitterSpitCount[client] = 0;
					g_bBindOneActive[client] = false;
					g_bBindOneCooldown[client] = true;
					g_iBindOneCooldown[client] = GetTime() + 30;
					SetConVarInt(FindConVar("z_spit_interval"), 5);
					g_hBindOneCooldown[client] = CreateTimer(30.0, Timer_BindOneCooldown, client);
				}
			}
		}
	}
}

public Event_TongueGrab(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		new Float:fSpeed = FloatMul(GetEntPropFloat(victim, Prop_Send, "m_flLaggedMovementValue"), 1.8);
		SetEntPropFloat(victim, Prop_Send, "m_flLaggedMovementValue", fSpeed);
	}
}

public Event_TongueRelease(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (victim == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		if (IsPlayerAlive(victim) && !IsFakeClient(victim))
		{
			ApplySpeed(victim);
		}

		else if (IsPlayerAlive(victim) && IsFakeClient(victim))
		{
			ResetSpeed(victim);
		}
	}
}

public Event_ChokeStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (victim == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		g_iSmokerVictim[client] = victim;
	}
}

public Event_ChokeEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (victim == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		g_iSmokerVictim[client] = 0;
	}
}

public Event_JockeyRide(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		g_iJockeyVictim[client] = victim;

		new Float:fSpeed = FloatMul(GetEntPropFloat(victim, Prop_Send, "m_flLaggedMovementValue"), 1.3);
		SetEntPropFloat(victim, Prop_Send, "m_flLaggedMovementValue", fSpeed);
	}
}

public Event_JockeyRideEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		g_iJockeyVictim[client] = 0;

		if (IsPlayerAlive(victim) && !IsFakeClient(victim))
		{
			ApplySpeed(victim);
		}

		else if (IsPlayerAlive(victim) && IsFakeClient(victim))
		{
			ResetSpeed(victim);
		}
	}
}

public Event_ChargerChargeStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		if (g_bBindOneActive[client])
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 2.0);
			g_iBindOneUses[client]--;
			g_bBindOneCooldown[client] = true;
			g_iBindOneCooldown[client] = GetTime() + 30;
			g_hBindOneCooldown[client] = CreateTimer(30.0, Timer_BindOneCooldown, client);
		}

		if (IsPlayerConfirmed(client) && IsClassCharger(client))
		{
			CreateTimer(0.1, Timer_ChargeIncapCheck, client);
		}
	}
}

public Event_ChargerChargeEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerInfected(client) && IsPlayerAlive(client) && !IsPlayerGhost(client))
	{
		if (IsPlayerAlive(client) && g_bBindOneActive[client])
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
			g_bBindOneActive[client] = false;
		}
	}

	if (IsClientInGame(client) && IsPlayerCharger(client) && IsClassCharger(client) && IsPlayerConfirmed(client))
	{
		new Float:f_Origin[3], Float:f_Angles[3], Float:f_EndOrigin[3], Float:f_Velocity[3],
			Handle:h_Trace, i_Target, String:s_ClassName[16], Float:f_Power, String:s_ModelName[64],
			i_Type;

		GetClientAbsOrigin(client, f_Origin);
		GetClientAbsAngles(client, f_Angles);
		f_Origin[2] += 20.0;

		h_Trace = TR_TraceRayFilterEx(f_Origin, f_Angles, MASK_ALL, RayType_Infinite, TraceFilterClients, client);

		if (TR_DidHit(h_Trace))
		{
			i_Target = TR_GetEntityIndex(h_Trace);
			TR_GetEndPosition(f_EndOrigin, h_Trace);

			if (i_Target && IsValidEdict(i_Target) && GetVectorDistance(f_Origin, f_EndOrigin) <= 100.0)
			{
				if (GetEntityMoveType(i_Target) != MOVETYPE_VPHYSICS)
				{
					return;
				}

				i_Type = 13;

				GetEdictClassname(i_Target, s_ClassName, sizeof(s_ClassName));
				GetEntPropString(i_Target, Prop_Data, "m_ModelName", s_ModelName, sizeof(s_ModelName));

				if (StrEqual(s_ClassName, "prop_physics") || StrEqual(s_ClassName, "prop_car_alarm"))
				{
					if (StrEqual(s_ClassName, "prop_car_alarm") && !(i_Type & (1<<1)))
					{
						return;
					}

					else if (StrContains(s_ModelName, "car") != -1 && !(i_Type & (1<<0)) && !(i_Type & (1<<1)))
					{
						return;
					}

					else if (StrContains(s_ModelName, "dumpster") != -1 && !(i_Type & (1<<2)))
					{
						return;
					}

					else if (StrContains(s_ModelName, "forklift") != -1 && !(i_Type & (1<<3)))
					{
						return;
					}

					GetAngleVectors(f_Angles, f_Velocity, NULL_VECTOR, NULL_VECTOR);
					f_Power = 1100.0;
					f_Velocity[0] *= f_Power;
					f_Velocity[1] *= f_Power;
					f_Velocity[2] *= f_Power;
					TeleportEntity(i_Target, NULL_VECTOR, NULL_VECTOR, f_Velocity);
				}
			}
		}

		return;
	}
}

public bool:TraceFilterClients(i_Entity, i_Mask, any:i_Data)
{
	if (i_Entity == i_Data)
		return false;

	if (1 <= i_Entity <= MaxClients)
		return false;

	return true;
}











public Event_WitchSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new entity = GetEventInt(event, "witchid");

	if (g_bSpawningWitch)
	{
		g_bSpawningWitch = false;
		SetEntityModel(entity, MODEL_HIDDEN_WITCH);
	}
}

public Event_WitchHarasserSet(Handle:event, const String:name[], bool:dontBroadcast)
{
	new entity = GetEventInt(event, "witchid");

	SetEntityModel(entity, MODEL_NORMAL_WITCH);
}

public Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));

	if (attacker == 0)
	{
		return;
	}

	if (IsClientInGame(attacker) && !IsFakeClient(attacker) && IsPlayerSurvivor(attacker) && IsPlayerAlive(attacker) && g_bFireMode[attacker])
	{
		IgniteEntity(victim, 30.0);
	}

	if (IsClientInGame(attacker) && !IsFakeClient(attacker) && IsPlayerInfected(attacker))
	{
		if (IsPlayerHunter(attacker) && IsPlayerSurvivor(victim) && g_bBindTwoActive[attacker] && !g_bBindTwoCooldown[attacker])
		{
			g_bBindTwoActive[attacker] = false;
			g_iBindTwoUses[attacker]--;
			g_bBindTwoCooldown[attacker] = true;
			g_iBindTwoCooldown[attacker] = GetTime() + 25;

			new Handle:hPack;
			CreateDataTimer(1.0, Timer_HunterPoison, hPack);
			WritePackCell(hPack, victim);
			WritePackCell(hPack, attacker);
			g_hBindTwoCooldown[attacker] = CreateTimer(25.0, Timer_BindTwoCooldown, attacker);
		}
	}
}

public Event_InfectedHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "attacker"));
	new entity = GetEventInt(event, "entityid");

	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client) && IsPlayerSurvivor(client) && IsPlayerAlive(client) && g_bFireMode[client])
	{
		IgniteEntity(entity, 30.0);
	}
}

public Event_LeftStartArea(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && !IsFakeClient(x) && !IsPlayerConfirmed(x))
		{
			PrintHintText(x, "Don't forget to confirm your setup!");
		}
	}
}

public Event_PounceEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client == 0)
	{
		return;
	}

	if (IsClientInGame(client) && !IsFakeClient(client))
	{
		g_bInfectedSelectCooldown[client] = false;
	}
}

public Event_PounceLunge(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));

	if (attacker == 0 || victim == 0)
	{
		return;
	}

	if (IsClientInGame(attacker) && !IsFakeClient(attacker))
	{
		if (IsPlayerHunter(attacker) && IsClassHunter(attacker) && g_bHunterPounceActive[attacker])
		{
			g_bHunterPounceActive[attacker] = false;
			g_bHunterPounceCooldown[attacker] = true;
			g_iHunterPounceCooldown[attacker] = GetTime() + 15;
			g_hHunterPounceCooldown[attacker] = CreateTimer(15.0, Timer_HunterPounceCooldown, attacker);
			ApplyDamage(attacker, victim, 15);
		}
	}
}

public Action:NormalSHook(clients[64], &numClients, String:sample[PLATFORM_MAX_PATH], &entity, &channel, &Float:volume, &level, &pitch, &flags)
{
	if (entity <= 0 || entity > MaxClients)
	{
		return Plugin_Continue;
	}

	if (IsClientInGame(entity))
	{
		if (IsPlayerSurvivor(entity) && IsPlayerAlive(entity) && IsPlayerConfirmed(entity) && IsClassRecon(entity))
		{
			if (StrEqual(sample, "player/damage1.wav") || StrContains(sample, "Fall01.wav") || StrContains(sample, "Fall02.wav") || StrContains(sample, "Fall03.wav") || StrContains(sample, "Fall04.wav"))
			{
				return Plugin_Handled;
			}
		}

		if (IsPlayerInfected(entity) && IsPlayerHunter(entity) && IsPlayerAlive(entity) && IsPlayerConfirmed(entity) && IsClassHunter(entity) && IsPlayerGrounded(entity) && g_bHunterInvisibilityActive[entity])
		{
			if (StrContains(sample, "hunter_stalk") || StrContains(sample, "hunter_warn") || StrContains(sample, "hunter_alert"))
			{
				return Plugin_Handled;
			}
		}
	}

	return Plugin_Continue;
}

public Action:SoH_MagEnd2 (Handle:timer, Handle:hPack)
{
	KillTimer(timer);
	if (IsServerProcessing()==false)
	{
		CloseHandle(hPack);
		return Plugin_Stop;
	}

	ResetPack(hPack);
	new client = ReadPackCell(hPack);
	new Float:flStartTime_calc = ReadPackFloat(hPack);
	CloseHandle(hPack);

	if (client <= 0
		|| IsValidEntity(client)==false
		|| IsClientInGame(client)==false)
		return Plugin_Stop;

	//experimental, remove annoying double-playback
	new iVMid = GetEntDataEnt2(client, g_iViewModelO);
	SetEntDataFloat(iVMid, g_iVMStartTimeO, flStartTime_calc, true);

	return Plugin_Stop;
}

/*
#define IN_ATTACK        (1 << 0)
#define IN_JUMP               (1 << 1)
#define IN_DUCK               (1 << 2)
#define IN_FORWARD        (1 << 3)
#define IN_BACK               (1 << 4)
#define IN_USE               (1 << 5)
#define IN_CANCEL        (1 << 6)
#define IN_LEFT               (1 << 7)
#define IN_RIGHT        (1 << 8)
#define IN_MOVELEFT        (1 << 9)
#define IN_MOVERIGHT        (1 << 10)
#define IN_ATTACK2        (1 << 11)
#define IN_RUN               (1 << 12)
#define IN_RELOAD        (1 << 13)
#define IN_ALT1               (1 << 14)
#define IN_ALT2               (1 << 15)
#define IN_SCORE        (1 << 16)       // Used by client.dll for when scoreboard is held down
#define IN_SPEED        (1 << 17)    // Player is holding the speed key
#define IN_WALK               (1 << 18)    // Player holding walk key
#define IN_ZOOM               (1 << 19)    // Zoom key for HUD zoom
#define IN_WEAPON1        (1 << 20)    // weapon defines these bits
#define IN_WEAPON2        (1 << 21)    // weapon defines these bits
#define IN_BULLRUSH        (1 << 22)
#define IN_GRENADE1        (1 << 23)    // grenade 1
#define IN_GRENADE2        (1 << 24)    // grenade 2
*/

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if (IsClientInGame(client) && !IsFakeClient(client))
	{
		if (IsPlayerSurvivor(client))
		{
			if (IsPlayerAlive(client))
			{
				if (IsClassProtector(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_ATTACK)
					{
						new String:name[64];
						GetClientWeapon(client, name, sizeof(name));

						if (StrEqual(name, "weapon_melee"))
						{
							if (GetPlayerWeaponSlot(client, 1) > 0)
							{
								new Float:Amount = 1.02;
								new Float:m_flNextPrimaryAttack = GetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextPrimaryAttack");
								new Float:m_flNextSecondaryAttack = GetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextSecondaryAttack");
								SetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flPlaybackRate", Amount);
								SetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextPrimaryAttack", m_flNextPrimaryAttack - ((Amount - 1.0) / 2));
								SetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextSecondaryAttack", m_flNextSecondaryAttack - ((Amount - 1.0) / 2));
							}
						}
					}

					if (buttons & IN_ATTACK2)
					{
						SetEntData(client, FindSendPropInfo("CTerrorPlayer", "m_iShovePenalty"), 0, 4);
					}
				}

				if (IsClassCommando(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_ATTACK || buttons & IN_ATTACK2)
					{
						new String:name[64];
						GetClientWeapon(client, name, sizeof(name));

						if (StrEqual(name, "weapon_smg") || StrEqual(name, "weapon_smg_silenced") || StrEqual(name, "weapon_smg_mp5") || StrEqual(name, "weapon_rifle") || StrEqual(name, "weapon_rifle_sg552") || StrEqual(name, "weapon_rifle_ak47") || StrEqual(name, "weapon_autoshotgun") || StrEqual(name, "weapon_shotgun_spas") || StrEqual(name, "weapon_rifle_m60") || StrEqual(name, "weapon_sniper_awp") || StrEqual(name, "weapon_sniper_military") || StrEqual(name, "weapon_sniper_scout") || StrEqual(name, "weapon_hunting_rifle") || StrEqual(name, "weapon_pumpshotgun") || StrEqual(name, "weapon_shotgun_chrome"))
						{
							if (GetPlayerWeaponSlot(client, 0) > 0)
							{
								new Float:Amount = 1.07;
								new Float:m_flNextPrimaryAttack = GetEntPropFloat(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_flNextPrimaryAttack");
								new Float:m_flNextSecondaryAttack = GetEntPropFloat(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_flNextSecondaryAttack");
								new Float:m_flCycle = GetEntPropFloat(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_flCycle");
								new m_bInReload = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_bInReload");
								if (m_flCycle == 0.000000 && m_bInReload < 1)
								{
									SetEntPropFloat(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_flPlaybackRate", Amount);
									SetEntPropFloat(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_flNextPrimaryAttack", m_flNextPrimaryAttack - ((Amount - 1.0) / 2));
									SetEntPropFloat(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_flNextSecondaryAttack", m_flNextSecondaryAttack - ((Amount - 1.0) / 2));
								}
							}
						}

						else if (StrEqual(name, "weapon_pistol_magnum"))
						{
							if (GetPlayerWeaponSlot(client, 1) > 0)
							{
								new Float:Amount = 1.4;
								new Float:m_flNextPrimaryAttack = GetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextPrimaryAttack");
								new Float:m_flNextSecondaryAttack = GetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextSecondaryAttack");
								SetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flPlaybackRate", Amount);
								SetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextPrimaryAttack", m_flNextPrimaryAttack - ((Amount - 1.0) / 2));
								SetEntPropFloat(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_flNextSecondaryAttack", m_flNextSecondaryAttack - ((Amount - 1.0) / 2));
							}
						}
					}
				}

				if (IsClassRecon(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_DUCK)
					{
						if (g_bReconJumpActive[client])
						{
							PrintHintText(client, "Jump is charged!");
						}

						else if (g_bReconJumpCooldown[client])
						{
							new iRawTime = g_iReconJumpCooldown[client] - GetTime();
							new iHours = (iRawTime / 3600);
							new iMinutes = ((iRawTime % 3600) / 60);
							new iSeconds = ((iRawTime % 3600) % 60);
							new String:sCooldownTime[256];
							if (g_iReconJumpCooldown[client] > 0)
							{
								if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
								else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
								else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
							}

							PrintHintText(client, "You must wait %s before charging jump!", sCooldownTime);
						}

						else if (g_bReconJumpCharging[client])
						{
							if (g_iReconJumpCharged[client] > GetTime())
							{
								new iRawTime = g_iReconJumpCharged[client] - GetTime();
								new iHours = (iRawTime / 3600);
								new iMinutes = ((iRawTime % 3600) / 60);
								new iSeconds = ((iRawTime % 3600) % 60);
								new String:sCooldownTime[256];
								if (g_iReconJumpCharged[client] > 0)
								{
									if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
									else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
									else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
								}

								PrintHintText(client, "Jump will be charged in %s!", sCooldownTime);
							}

							else
							{
								g_iReconJumpCharged[client] = 0;
								g_bReconJumpActive[client] = true;
								g_bReconJumpCharging[client] = false;
							}
						}

						else
						{
							g_bReconJumpCharging[client] = true;
							g_iReconJumpCharged[client] = GetTime() + 2;
						}
					}
				}

				if (!(buttons & IN_DUCK))
				{
					if (g_bReconJumpCharging[client])
					{
						g_iReconJumpCharged[client] = 0;
						g_bReconJumpCharging[client] = false;
					}
				}

				if (buttons & IN_JUMP)
				{
					if (g_bReconJumpActive[client] && !IsPlayerIncapped(client))
					{
						decl Float:cVel[3];
						cVel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
						cVel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
						cVel[2] = 800.0; // upspeed, the higher this is, the higher is the jump
						TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, cVel);

						g_bReconJumpActive[client] = false;
						g_bReconJumpCooldown[client] = true;
						g_iReconJumpCooldown[client] = GetTime() + 2;
						g_hReconJumpCooldown[client] = CreateTimer(2.0, Timer_ReconJumpCooldown, client);
					}
				}
			}
		}

		if (IsPlayerInfected(client))
		{
			if (IsPlayerAlive(client) && !IsPlayerGhost(client))
			{
				if (IsPlayerCharger(client) && IsClassCharger(client) && IsPlayerConfirmed(client))
				{
					//Charger Earthquake
					if (buttons & IN_ATTACK2)
					{
						if (g_bBindTwoActive[client])
						{
							Earthquake(client);
							g_bBindTwoActive[client] = false;
							g_iBindTwoUses[client]--;
							g_bBindTwoCooldown[client] = true;
							g_iBindTwoCooldown[client] = GetTime() + 35;
							g_hBindTwoCooldown[client] = CreateTimer(35.0, Timer_BindTwoCooldown, client);
						}
					}

					//Charger Uppercut
					if (buttons & IN_DUCK)
					{
						if (g_bChargerUppercutActive[client])
						{
							PrintHintText(client, "Uppercut is charged!");
						}

						else if (g_bChargerUppercutCooldown[client])
						{
							new iRawTime = g_iChargerUppercutCooldown[client] - GetTime();
							new iHours = (iRawTime / 3600);
							new iMinutes = ((iRawTime % 3600) / 60);
							new iSeconds = ((iRawTime % 3600) % 60);
							new String:sCooldownTime[256];
							if (g_iChargerUppercutCooldown[client] > 0)
							{
								if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
								else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
								else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
							}

							PrintHintText(client, "You must wait %s before charging uppercut!", sCooldownTime);
						}

						else if (g_bChargerUppercutCharging[client])
						{
							if (g_iChargerUppercutCharged[client] > GetTime())
							{
								new iRawTime = g_iChargerUppercutCharged[client] - GetTime();
								new iHours = (iRawTime / 3600);
								new iMinutes = ((iRawTime % 3600) / 60);
								new iSeconds = ((iRawTime % 3600) % 60);
								new String:sCooldownTime[256];
								if (g_iChargerUppercutCharged[client] > 0)
								{
									if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
									else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
									else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
								}

								PrintHintText(client, "Uppercut will be charged in %s!", sCooldownTime);
							}

							else
							{
								g_iChargerUppercutCharged[client] = 0;
								g_bChargerUppercutActive[client] = true;
								g_bChargerUppercutCharging[client] = false;
							}
						}

						else
						{
							g_bChargerUppercutCharging[client] = true;
							g_iChargerUppercutCharged[client] = GetTime() + 5;
						}
					}

					if (!(buttons & IN_DUCK))
					{
						if (g_bChargerUppercutCharging[client])
						{
							g_iChargerUppercutCharged[client] = 0;
							g_bChargerUppercutCharging[client] = false;
						}
					}
				}

				//Spitter Shift
				if (IsPlayerSpitter(client) && IsClassSpitter(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_DUCK)
					{
						if (g_bSpitterShiftActive[client])
						{
							PrintHintText(client, "Shift is charged!");
						}

						else if (g_bSpitterShiftCooldown[client])
						{
							new iRawTime = g_iSpitterShiftCooldown[client] - GetTime();
							new iHours = (iRawTime / 3600);
							new iMinutes = ((iRawTime % 3600) / 60);
							new iSeconds = ((iRawTime % 3600) % 60);
							new String:sCooldownTime[256];
							if (g_iSpitterShiftCooldown[client] > 0)
							{
								if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
								else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
								else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
							}

							PrintHintText(client, "You must wait %s before charging shift!", sCooldownTime);
						}

						else if (g_bSpitterShiftCharging[client])
						{
							if (g_iSpitterShiftCharged[client] > GetTime())
							{
								new iRawTime = g_iSpitterShiftCharged[client] - GetTime();
								new iHours = (iRawTime / 3600);
								new iMinutes = ((iRawTime % 3600) / 60);
								new iSeconds = ((iRawTime % 3600) % 60);
								new String:sCooldownTime[256];
								if (g_iSpitterShiftCharged[client] > 0)
								{
									if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
									else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
									else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
								}

								PrintHintText(client, "Shift will be charged in %s!", sCooldownTime);
							}

							else
							{
								g_iSpitterShiftCharged[client] = 0;
								g_bSpitterShiftActive[client] = true;
								g_bSpitterShiftCharging[client] = false;

								SetEntityRenderMode(client, RENDER_TRANSCOLOR);
								SetEntityRenderColor(client, 255, 255, 255, 64);
								SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 2.0);

								g_hSpitterShiftActive[client] = CreateTimer(10.0, Timer_SpitterShiftActive, client);
							}
						}

						else
						{
							g_bSpitterShiftCharging[client] = true;
							g_iSpitterShiftCharged[client] = GetTime() + 5;
						}
					}

					if (!(buttons & IN_DUCK))
					{
						if (g_bSpitterShiftCharging[client])
						{
							g_iSpitterShiftCharged[client] = 0;
							g_bSpitterShiftCharging[client] = false;
						}
					}
				}

				//Hunter Pounce
				if (IsPlayerHunter(client) && IsClassHunter(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_DUCK)
					{
						if (g_bHunterPounceActive[client])
						{
							PrintHintText(client, "Pounce damage is charged!");
						}

						else if (g_bHunterPounceCooldown[client])
						{
							new iRawTime = g_iHunterPounceCooldown[client] - GetTime();
							new iHours = (iRawTime / 3600);
							new iMinutes = ((iRawTime % 3600) / 60);
							new iSeconds = ((iRawTime % 3600) % 60);
							new String:sCooldownTime[256];
							if (g_iHunterPounceCooldown[client] > 0)
							{
								if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
								else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
								else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
							}

							PrintHintText(client, "You must wait %s before charging pounce damage!", sCooldownTime);
						}

						else if (g_bHunterPounceCharging[client])
						{
							if (g_iHunterPounceCharged[client] > GetTime())
							{
								new iRawTime = g_iHunterPounceCharged[client] - GetTime();
								new iHours = (iRawTime / 3600);
								new iMinutes = ((iRawTime % 3600) / 60);
								new iSeconds = ((iRawTime % 3600) % 60);
								new String:sCooldownTime[256];
								if (g_iHunterPounceCharged[client] > 0)
								{
									if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
									else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
									else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
								}

								PrintHintText(client, "Pounce damage will be charged in %s!", sCooldownTime);
							}

							else
							{
								g_iHunterPounceCharged[client] = 0;
								g_bHunterPounceActive[client] = true;
								g_bHunterPounceCharging[client] = false;
							}
						}

						else
						{
							g_bHunterPounceCharging[client] = true;
							g_iHunterPounceCharged[client] = GetTime() + 15;
						}
					}

					if ((!(buttons & IN_DUCK) || !IsPlayerGrounded(client)))
					{
						if (g_bHunterPounceCharging[client])
						{
							g_iHunterPounceCharged[client] = 0;
							g_bHunterPounceCharging[client] = false;
						}
					}
				}

				//Hunter Invisibility
				if (IsPlayerHunter(client) && IsClassHunter(client) && IsPlayerConfirmed(client))
				{
					if ((buttons & IN_FORWARD || buttons & IN_BACK || buttons & IN_MOVELEFT || buttons & IN_MOVERIGHT) || !IsPlayerGrounded(client))
					{
						if (g_bHunterInvisibilityActive[client])
						{
							ResetColor(client);
							g_bHunterInvisibilityActive[client] = false;
							g_iHunterVisiblityTicks[client] = 0;
							// g_hHunterVisibilityActive[client] = CreateTimer(0.001, Timer_HunterVisibility, client);
						}
					}

					else
					{
						if (!g_bHunterInvisibilityActive[client])
						{
							g_bHunterInvisibilityActive[client] = true;
							g_iHunterInvisiblityTicks[client] = 51;
							g_hHunterInvisibilityActive[client] = CreateTimer(0.001, Timer_HunterInvisibility, client);
						}
					}
				}

				//Boomer Jump
				if (IsPlayerBoomer(client) && IsClassBoomer(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_JUMP)
					{
						if (g_bBindTwoActive[client] && IsPlayerGrounded(client))
						{
							SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 3.0);
							SetEntityGravity(client, 0.8);
							decl Float:cVel[3];
							cVel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
							cVel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
							cVel[2] = 1450.0; // upspeed, the higher this is, the higher is the jump
							TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, cVel);

							g_iBindTwoUses[client]--;
							SDKHook(client, SDKHook_StartTouch, Hook_StartTouch);
						}
					}

				}

				//Jockey Jump
				if (IsPlayerJockey(client) && IsClassJockey(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_JUMP)
					{
						if (g_bJockeyJumpCooldown[client] && g_iJockeyVictim[client] > 0 && IsPlayerGrounded(client))
						{
							new iRawTime = g_iJockeyJumpCooldown[client] - GetTime();
							new iHours = (iRawTime / 3600);
							new iMinutes = ((iRawTime % 3600) / 60);
							new iSeconds = ((iRawTime % 3600) % 60);
							new String:sCooldownTime[256];
							if (g_iJockeyJumpCooldown[client] > 0)
							{
								if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
								else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
								else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
							}

							PrintHintText(client, "You must wait %s before jumping again!", sCooldownTime);
						}

						else if (g_iJockeyVictim[client] > 0 && IsPlayerGrounded(client))
						{
							g_bJockeyJumpCooldown[client] = true;
							g_iJockeyJumpCooldown[client] = GetTime() + 10;
							g_hJockeyJumpCooldown[client] = CreateTimer(10.0, Timer_JockeyJumpCooldown, client);
							JockeyJump(g_iJockeyVictim[client]);
						}
					}
				}

				//Tank Roar
				if (IsPlayerTank(client) && IsPlayerConfirmed(client))
				{
					if (buttons & IN_ZOOM)
					{
						if (g_bTankRoarCooldown[client])
						{
							new iRawTime = g_iTankRoarCooldown[client] - GetTime();
							new iHours = (iRawTime / 3600);
							new iMinutes = ((iRawTime % 3600) / 60);
							new iSeconds = ((iRawTime % 3600) % 60);
							new String:sCooldownTime[256];
							if (g_iTankRoarCooldown[client] > 0)
							{
								if (iHours > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
								else if (iMinutes > 0) { Format(sCooldownTime, sizeof(sCooldownTime), "%dm %ds", iMinutes, iSeconds); }
								else { Format(sCooldownTime, sizeof(sCooldownTime), "%ds", iSeconds); }
							}

							PrintHintText(client, "You must wait %s before roaring again!", sCooldownTime);
						}

						else
						{
							g_bTankRoarCooldown[client] = true;
							g_iTankRoarCooldown[client] = GetTime() + 10;
							g_hTankRoarCooldown[client] = CreateTimer(10.0, Timer_TankRoarCooldown, client);
							TankRoar(client);
						}
					}
				}
			}

			if (IsPlayerAlive(client) && IsPlayerGhost(client))
			{
				if (buttons & IN_ATTACK2)
				{
					if (!g_bInfectedSelectCooldown[client])
					{
						g_bInfectedSelectCooldown[client] = true;
						DetermineClass(client);
					}
				}

				else
				{
					g_bInfectedSelectCooldown[client] = false;
				}
			}
		}
	}

	return Plugin_Continue;
}





//======================================================================================================================================================================================================================================================
//																								LISTENER CALLBACKS
//======================================================================================================================================================================================================================================================





public Action:Listener_Say(client, const String:command[], argc)
{
	if (g_hTDatabase != INVALID_HANDLE)
	{
		new String:sQuery[512], String:sHostname[128], String:sEscHostname[128], String:sName[MAX_NAME_LENGTH], String:sEscName[MAX_NAME_LENGTH], String:sMessage[MAX_MSG_LENGTH], String:sEscMessage[MAX_MSG_LENGTH];
		GetConVarString(FindConVar("hostname"), sHostname, sizeof(sHostname));
		GetClientName(client,sName,sizeof(sName));
		GetCmdArgString(sMessage,sizeof(sMessage));
		StripQuotes(sMessage);
		SQL_EscapeString(g_hTDatabase, sHostname, sEscHostname, sizeof(sEscHostname));
		SQL_EscapeString(g_hTDatabase, sName, sEscName, sizeof(sEscName));
		SQL_EscapeString(g_hTDatabase, sMessage, sEscMessage, sizeof(sEscMessage));
		Format(sQuery, sizeof(sQuery), "INSERT INTO chat_log (server_name, client_name, client_auth, client_ip, client_message) VALUES ('%s', '%s', '%s', '%s', '%s')", sEscHostname, sEscName, g_sAuth[client], g_sIP[client], sEscMessage);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_ListenerSay, sQuery);
	}

	return Plugin_Continue;
}





//======================================================================================================================================================================================================================================================
//																								TIMER CALLBACKS
//======================================================================================================================================================================================================================================================






public Action:Timer_Positions(Handle:timer)
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerAlive(x))
		{
			GetClientAbsOrigin(x, g_fPosition[x]);
		}
	}
}

public Action:Timer_JockeyPeeSound(Handle:timer, any:client)
{
	StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
	StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
	StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
	StopSound(client, SNDCHAN_AUTO, SOUND_JOCKEY_PEE);
}

public Action:Timer_BindOneCooldown(Handle:timer, any:client)
{
	g_bBindOneCooldown[client] = false;
	g_iBindOneCooldown[client] = 0;
	g_hBindOneCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_BindTwoCooldown(Handle:timer, any:client)
{
	g_bBindTwoCooldown[client] = false;
	g_iBindTwoCooldown[client] = 0;
	g_hBindTwoCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_BindWitchCooldown(Handle:timer, any:client)
{
	g_bBindWitchCooldown[client] = false;
	g_iBindWitchCooldown[client] = 0;
	g_hBindWitchCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_JockeyJumpCooldown(Handle:timer, any:client)
{
	g_bJockeyJumpCooldown[client] = false;
	g_iJockeyJumpCooldown[client] = 0;
	g_hJockeyJumpCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_TankRoarCooldown(Handle:timer, any:client)
{
	g_bTankRoarCooldown[client] = false;
	g_iTankRoarCooldown[client] = 0;
	g_hTankRoarCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_ChargerUppercutCooldown(Handle:timer, any:client)
{
	g_bChargerUppercutCooldown[client] = false;
	g_iChargerUppercutCooldown[client] = 0;
	g_hChargerUppercutCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_ReconJumpCooldown(Handle:timer, any:client)
{
	g_bReconJumpCooldown[client] = false;
	g_iReconJumpCooldown[client] = 0;
	g_hReconJumpCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_SpitterShiftActive(Handle:timer, any:client)
{
	if (IsFakeClient(client))
	{
		ResetColor(client);
		ResetSpeed(client);
	}

	else if (IsFakeClient(client))
	{
		ApplySpeed(client);
		ApplyColor(client);
	}

	g_bSpitterShiftActive[client] = false;
	g_bSpitterShiftCooldown[client] = true;
	g_iSpitterShiftCooldown[client] = GetTime() + 30;
	g_hSpitterShiftCooldown[client] = CreateTimer(30.0, Timer_SpitterShiftCooldown, client);
	g_hSpitterShiftActive[client] = INVALID_HANDLE;
}

public Action:Timer_SpitterShiftCooldown(Handle:timer, any:client)
{
	g_bSpitterShiftCooldown[client] = false;
	g_iSpitterShiftCooldown[client] = 0;
	g_hSpitterShiftCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_HunterPounceCooldown(Handle:timer, any:client)
{
	g_bHunterPounceCooldown[client] = false;
	g_iHunterPounceCooldown[client] = 0;
	g_hHunterPounceCooldown[client] = INVALID_HANDLE;
}

public Action:Timer_MedicCrouch(Handle:timer)
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && !IsFakeClient(x) && IsPlayerSurvivor(x) && IsPlayerConfirmed(x) && IsClassMedic(x) && GetClientButtons(x) & IN_DUCK)
		{
			MedicAOE(x);
		}
	}
}

public Action:Timer_SupportCrouch(Handle:timer)
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && !IsFakeClient(x) && IsPlayerSurvivor(x) && IsPlayerConfirmed(x) && IsClassSupport(x) && GetClientButtons(x) & IN_DUCK)
		{
			SupportAOE(x);
		}
	}
}

public Action:Timer_InfectedGlow(Handle:timer, any:client)
{
	g_bInfectedGlow = false;

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerInfected(x) && IsPlayerAlive(x))
		{
			StopGlow(x);
		}
	}

	PrintHintText(client, "Special infected will no longer glow!");
}

public Action:Timer_FireMode(Handle:timer, any:client)
{
	g_bFireMode[client] = false;
	g_hFireMode[client] = INVALID_HANDLE;

	StopSound(client, SNDCHAN_AUTO, SOUND_COMMANDO_FIRE);
	PrintHintText(client, "You are no longer in fire mode!");
}

public Action:Timer_PipeBomb(Handle:timer, any:client)
{
	if (g_iPipeBombTicks[client] < 3)
	{
		g_iPipeBombTicks[client]++;
		Pipebomb(client);
		g_hPipeBomb[client] = CreateTimer(1.0, Timer_PipeBomb, client);
	}

	else
	{
		g_iPipeBombTicks[client] = 0;
		g_hPipeBomb[client] = INVALID_HANDLE;
	}
}

public Action:Timer_BoomerHotMeal(Handle:timer, any:client)
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		g_bBindOneActive[client] = false;
		g_hBoomerHotMeal[client] = INVALID_HANDLE;
		SetConVarInt(FindConVar("z_vomit_interval"), 10);
		ApplySpeed(client);
	}
}

public Action:Timer_HunterPoison(Handle:timer, Handle:hPack)
{
	ResetPack(hPack);
	new victim = ReadPackCell(hPack);
	new attacker = ReadPackCell(hPack);

	if (g_iHunterPoisonTicks[victim] < 10)
	{
		g_iHunterPoisonTicks[victim]++;
		ApplyDamage(attacker, victim, 3);
		CreateDataTimer(1.0, Timer_HunterPoison, hPack);
		WritePackCell(hPack, victim);
		WritePackCell(hPack, attacker);
	}

	else
	{
		g_iHunterPoisonTicks[victim] = 0;
	}
}

public Action:Timer_HunterInvisibility(Handle:timer, any:client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}

	if (g_bHunterInvisibilityActive[client])
	{
		if (g_iHunterInvisiblityTicks[client] > 0)
		{
			//PrintToChatAll("Invisibility: %d", g_iHunterInvisiblityTicks[client]);
			g_iHunterInvisiblityTicks[client]--;
			SetEntityRenderColor(client, 255, 255, 255, g_iHunterInvisiblityTicks[client] * 5);
			g_hHunterInvisibilityActive[client] = CreateTimer(0.001, Timer_HunterInvisibility, client);
		}

		else
		{
			//PrintToChatAll("Invisibility: %d", g_iHunterInvisiblityTicks[client]);
			SetEntityRenderColor(client, 255, 255, 255, 0);
			g_iHunterInvisiblityTicks[client] = 51;
			g_hHunterInvisibilityActive[client] = INVALID_HANDLE;
		}
	}

	else
	{
		g_iHunterInvisiblityTicks[client] = 0;
		g_hHunterInvisibilityActive[client] = INVALID_HANDLE;
	}
}

public Action:Timer_HunterVisibility(Handle:timer, any:client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}

	if (!g_bHunterInvisibilityActive[client])
	{
		if (g_iHunterVisiblityTicks[client] < 17)
		{
			PrintToChatAll("Visibility: %d", g_iHunterVisiblityTicks[client]);
			g_iHunterVisiblityTicks[client]++;
			SetEntityRenderColor(client, 255, 255, 255, g_iHunterVisiblityTicks[client] * 15);
			g_hHunterVisibilityActive[client] = CreateTimer(0.001, Timer_HunterVisibility, client);
		}

		else
		{
			PrintToChatAll("Visibility: %d", g_iHunterVisiblityTicks[client]);
			SetEntityRenderColor(client, 255, 255, 255, 255);
			g_iHunterVisiblityTicks[client] = 0;
			g_hHunterVisibilityActive[client] = INVALID_HANDLE;
		}
	}

	else
	{
		g_iHunterVisiblityTicks[client] = 17;
		g_hHunterVisibilityActive[client] = INVALID_HANDLE;
	}
}

public Action:Timer_JockeyInvisibility(Handle:timer, any:client)
{
	if (client == 0)
	{
		return;
	}

	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}

	g_bJockeyInvisibility[client] = false;
	g_hJockeyInvisibility[client] = INVALID_HANDLE;
	SDKUnhook(client, SDKHook_SetTransmit, Hook_SetTransmit);

	if (IsFakeClient(client))
	{
		ResetColor(client);
	}

	else if (!IsFakeClient(client))
	{
		ApplyColor(client);
	}
}

public Action:Timer_SmokerInvisibility(Handle:timer, any:client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}

	if (g_iSmokerInvisibilityTicks[client] < 51)
	{
		g_iSmokerInvisibilityTicks[client]++;
		SetEntityRenderColor(client, 255, 255, 255, g_iSmokerInvisibilityTicks[client] * 5);
		g_hSmokerInvisibility[client] = CreateTimer(0.001, Timer_SmokerInvisibility, client);
	}

	else
	{
		g_iSmokerInvisibilityTicks[client] = 0;
		g_hSmokerInvisibility[client] = INVALID_HANDLE;
	}
}

public Action:Timer_SmokerElectricity(Handle:timer, any:client)
{
	if (g_iSmokerVictim[client] <= 0)
	{
		return;
	}

	if (g_iSmokerElectricityTicks[g_iSmokerVictim[client]] < 6)
	{
		g_iSmokerElectricityTicks[g_iSmokerVictim[client]]++;
		Electrocute(client, g_iSmokerVictim[client]);
		g_hSmokerElectricity[client] = CreateTimer(0.5, Timer_SmokerElectricity, client);
	}

	else
	{
		g_iSmokerElectricityTicks[g_iSmokerVictim[client]] = 0;
		g_hSmokerElectricity[client] = INVALID_HANDLE;
	}
}

public Action:Timer_Boost(Handle:timer, any:client)
{
	g_bBoost[client] = false;
	g_hBoost[client] = INVALID_HANDLE;

	ApplySpeed(client);
	PrintHintText(client, "You are now back to normal speed!");
}

public Action:Timer_Invulnerability(Handle:timer, any:client)
{
	g_bInvulnerability[client] = false;
	g_hInvulnerability[client] = INVALID_HANDLE;

	SetEntProp(client, Prop_Data, "m_takedamage", 2);
	PrintHintText(client, "You are no longer invulnerable!");
}

public Action:Timer_Invisibility(Handle:timer, any:client)
{
	g_bInvisibility[client] = false;
	g_hInvisibility[client] = INVALID_HANDLE;

	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, 64, 64, 255, 255);
	new weapon_entity = GetPlayerWeaponSlot(client, 0);
	SetEntityRenderMode(weapon_entity, RENDER_TRANSCOLOR);
	SetEntityRenderColor(weapon_entity, 0, 0, 0, 0);
	PrintHintText(client, "You are no longer invisible!");
}

public Action:Timer_Stats(Handle:timer, any:client)
{
	if (IsClientInGame(client) && g_bStatsPanel[client])
	{
		DisplayStatsPanel(client);
	}
}

public Action:Timer_ChargeIncapCheck(Handle:timer, any:client)
{
	for (new target = 1; target <= MaxClients; target++)
	{
		if (IsClientInGame(target) && target != client && IsPlayerSurvivor(target) && IsPlayerIncapped(target) && !GetEntProp(target, Prop_Send, "m_isHangingFromLedge") && !GetEntProp(target, Prop_Send, "m_isFallingFromLedge"))
		{
			new Float:targetpos[3], Float:chargerpos[3];
			GetClientAbsOrigin(target, targetpos);
			GetClientAbsOrigin(client, chargerpos);

			if (GetVectorDistance(targetpos, chargerpos) < 150.0)
			{
				new health = GetClientHealth(target);
				SetEntProp(target, Prop_Send, "m_isIncapacitated", 0);

				new Handle:hPack;
				CreateDataTimer(1.0, Timer_chargeReIncap, hPack);
				WritePackCell(hPack, target);
				WritePackCell(hPack, health);
			}
		}
	}

	if (GetEntProp(GetEntPropEnt(client, Prop_Send, "m_customAbility"), Prop_Send, "m_isCharging"))
	{
		CreateTimer(0.1, Timer_ChargeIncapCheck, client);
	}
}

public Action:Timer_chargeReIncap(Handle:timer, Handle:hPack)
{
	ResetPack(hPack);
	new client = ReadPackCell(hPack);
	new health = ReadPackCell(hPack);

	SetEntProp(client, Prop_Send, "m_isIncapacitated", 1);
	SetEntityHealth(client, health);
}





//======================================================================================================================================================================================================================================================
//																								SQL STUFF
//======================================================================================================================================================================================================================================================





public OnSQLT_Connect(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogError("%s: Unable to connect to MySQL server: %s", PLUGIN_NAME, error);
	}

	else
	{
		g_hTDatabase = hndl;
	}
}

public OnSQLTQuery_AuthorizedClientInfo(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (!SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "INSERT INTO client_info (client_name,client_auth,client_ip) VALUES ('%s','%s','%s')", sEscName, g_sAuth[client], g_sIP[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);

		Format(g_sLastServer[client], sizeof(g_sLastServer[]), "None");
		g_iLastConnected[client] = 0;
		g_iTimePlayed[client] = 0;
	}

	else
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_info SET client_name='%s', client_ip='%s' WHERE client_auth='%s'", sEscName, g_sIP[client], g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);

		SQL_FetchString(hndl, 4, g_sLastServer[client], sizeof(g_sLastServer[]));
		g_iLastConnected[client] = SQL_FetchInt(hndl, 5);
		g_iTimePlayed[client] = SQL_FetchInt(hndl, 6);
	}
}

public OnSQLTQuery_AuthorizedClientStats(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (!SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "INSERT INTO client_stats (client_name,client_auth,client_ip) VALUES ('%s','%s','%s')", sEscName, g_sAuth[client], g_sIP[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);

		g_iSurvivorCommonKills[client] = 0;
		g_iSurvivorSpecialKills[client] = 0;
		g_iSurvivorTankKills[client] = 0;
		g_iSurvivorWitchKills[client] = 0;
		g_iSurvivorSurvivorIncaps[client] = 0;
		g_iSurvivorSurvivorDeaths[client] = 0;
		g_iInfectedSurvivorDamage[client] = 0;
		g_iInfectedSurvivorIncaps[client] = 0;
		g_iInfectedSurvivorKills[client] = 0;
		g_iInfectedSpecialDeaths[client] = 0;
	}

	else
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_stats SET client_name='%s', client_ip='%s' WHERE client_auth='%s'", sEscName, g_sIP[client], g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);

		g_iSurvivorCommonKills[client] = SQL_FetchInt(hndl, 4);
		g_iSurvivorSpecialKills[client] = SQL_FetchInt(hndl, 5);
		g_iSurvivorTankKills[client] = SQL_FetchInt(hndl, 6);
		g_iSurvivorWitchKills[client] = SQL_FetchInt(hndl, 7);
		g_iSurvivorSurvivorIncaps[client] = SQL_FetchInt(hndl, 8);
		g_iSurvivorSurvivorDeaths[client] = SQL_FetchInt(hndl, 9);
		g_iInfectedSurvivorDamage[client] = SQL_FetchInt(hndl, 10);
		g_iInfectedSurvivorIncaps[client] = SQL_FetchInt(hndl, 11);
		g_iInfectedSurvivorKills[client] = SQL_FetchInt(hndl, 12);
		g_iInfectedSpecialDeaths[client] = SQL_FetchInt(hndl, 13);
	}
}

public OnSQLTQuery_AuthorizedClientSurvivor(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (!SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "INSERT INTO client_survivor (client_name,client_auth,client_ip) VALUES ('%s','%s','%s')", sEscName, g_sAuth[client], g_sIP[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	else
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_survivor SET client_name='%s', client_ip='%s' WHERE client_auth='%s'", sEscName, g_sIP[client], g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);

		SQL_FetchString(hndl, 4, g_sSurvClass[client], sizeof(g_sSurvClass[]));
		SQL_FetchString(hndl, 5, g_sPrimary[client], sizeof(g_sPrimary[]));
		SQL_FetchString(hndl, 6, g_sSecondary[client], sizeof(g_sSecondary[]));
		SQL_FetchString(hndl, 7, g_sGrenade[client], sizeof(g_sGrenade[]));
		SQL_FetchString(hndl, 8, g_sHealth[client], sizeof(g_sHealth[]));
		SQL_FetchString(hndl, 9, g_sBoost[client], sizeof(g_sBoost[]));
	}
}

public OnSQLTQuery_AuthorizedClientInfected(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (!SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "INSERT INTO client_infected (client_name,client_auth,client_ip) VALUES ('%s','%s','%s')", sEscName, g_sAuth[client], g_sIP[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	else
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_infected SET client_name='%s', client_ip='%s' WHERE client_auth='%s'", sEscName, g_sIP[client], g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);

		SQL_FetchString(hndl, 4, g_sInfClassOne[client], sizeof(g_sInfClassOne[]));
		SQL_FetchString(hndl, 5, g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]));
		SQL_FetchString(hndl, 6, g_sInfClassThree[client], sizeof(g_sInfClassThree[]));
	}
}

public OnSQLTQuery_DisconnectClientInfo(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sHostname[128], String:sEscHostname[128];
		GetConVarString(FindConVar("hostname"), sHostname, sizeof(sHostname));
		SQL_EscapeString(g_hTDatabase, sHostname, sEscHostname, sizeof(sEscHostname));
		Format(sQuery, sizeof(sQuery), "UPDATE client_info SET last_connected='%d', last_server='%s' WHERE client_auth='%s'", GetTime(), sEscHostname, g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	return;
}

public OnSQLTQuery_DisconnectClientStats(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (SQL_FetchRow(hndl))
	{
		new String:sQuery[512];
		Format(sQuery, sizeof(sQuery), "UPDATE client_info SET time_played='%d' WHERE client_auth='%s'", g_iTimePlayed[client], g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
		Format(sQuery, sizeof(sQuery), "UPDATE client_stats SET survivor_common_kills='%d', survivor_special_kills='%d', survivor_tank_kills='%d', survivor_witch_kills='%d', survivor_survivor_incaps='%d', survivor_survivor_deaths='%d', infected_survivor_damage='%d', infected_survivor_incaps='%d', infected_survivor_kills='%d', infected_special_deaths='%d' WHERE client_auth='%s'", g_iSurvivorCommonKills[client], g_iSurvivorSpecialKills[client], g_iSurvivorTankKills[client], g_iSurvivorWitchKills[client], g_iSurvivorSurvivorIncaps[client], g_iSurvivorSurvivorDeaths[client], g_iInfectedSurvivorDamage[client], g_iInfectedSurvivorIncaps[client], g_iInfectedSurvivorKills[client], g_iInfectedSpecialDeaths[client], g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	return;
}

public OnSQLTQuery_ChangeNameClientInfo(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_info SET client_name='%s' WHERE client_auth='%s'", sEscName, g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	return;
}

public OnSQLTQuery_ChangeNameClientStats(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_stats SET client_name='%s' WHERE client_auth='%s'", sEscName, g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	return;
}

public OnSQLTQuery_ChangeNameClientSurvivor(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_survivor SET client_name='%s' WHERE client_auth='%s'", sEscName, g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	return;
}

public OnSQLTQuery_ChangeNameClientInfected(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	if (hndl == INVALID_HANDLE)
	{
		return;
	}

	if (SQL_FetchRow(hndl))
	{
		new String:sQuery[512], String:sEscName[MAX_NAME_LENGTH];
		SQL_EscapeString(g_hTDatabase, g_sName[client], sEscName, sizeof(sEscName));
		Format(sQuery, sizeof(sQuery), "UPDATE client_infected SET client_name='%s' WHERE client_auth='%s'", sEscName, g_sAuth[client]);
		SQL_TQuery(g_hTDatabase, OnSQLTQuery_InsertUpdate, sQuery);
	}

	return;
}

public OnSQLTQuery_InsertUpdate(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	return;
}

public OnSQLTQuery_ListenerSay(Handle:owner, Handle:hndl, const String:error[], any:client)
{
	return;
}





//============================================================================================================================================================================================================================================
//																								MAIN PANEL
//============================================================================================================================================================================================================================================





public DisplayMainPanel(client)
{
	new Handle:Panel_Main = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Main, sTitle);
	DrawPanelItem(Panel_Main, "Classes");
	DrawPanelItem(Panel_Main, "Equipment");
	DrawPanelItem(Panel_Main, "Options");
	if (!IsPlayerConfirmed(client)) { DrawPanelItem(Panel_Main, "Confirm"); }
	DrawPanelItem(Panel_Main, "Exit");

	SendPanelToClient(Panel_Main, client, Panel_Main_Handle, 60);
	CloseHandle(Panel_Main);
}


public Panel_Main_Handle(Handle:Panel_Main, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			if (IsPlayerConfirmed(client))
			{
				PrintHintText(client, "Wait until next round to adjust your setup!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayMainPanel(client);
				return;
			}

			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayClassesPanel(client);
		}

		if (param2 == 2)
		{
			if (IsPlayerConfirmed(client))
			{
				PrintHintText(client, "Wait until next round to adjust your setup!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayMainPanel(client);
				return;
			}

			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayOptionsPanel(client);
		}

		if (param2 == 4)
		{
			if (IsPlayerConfirmed(client))
			{
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				CancelClientMenu(client);
				return;
			}

			else
			{
				if (IsMissingSetup(client))
				{
					PrintHintText(client, "Fill all class and equipment slots before confirming!");
					EmitSoundToClient(client, SOUND_MENU_SELECT);
					DisplayMainPanel(client);
					return;
				}

				else if (IsPlayerSurvivor(client))
				{
					g_bConfirmedSetup[client] = true;

					if (IsPlayerAlive(client))
					{
						ApplyColor(client);
						ApplyHealth(client, client);
						ApplySpeed(client);
						ApplyCvars(client);
						GiveEquipment(client);
					}
				}

				else if (IsPlayerInfected(client))
				{
					g_bConfirmedSetup[client] = true;

					if (IsPlayerAlive(client) && !IsPlayerGhost(client))
					{
						ApplyColor(client);
						ApplyHealth(client, client);
						ApplySpeed(client);
						ApplyCvars(client);
					}
				}
			}

			PrintHintText(client, "Your setup is now confirmed!");
			EmitSoundToClient(client, SOUND_MENU_CONFIRM);
		}

		if (param2 == 5)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			CancelClientMenu(client);
			return;
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								CLASSES PANEL
//============================================================================================================================================================================================================================================





public DisplayClassesPanel(client)
{
	new Handle:Panel_Classes = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Classes, sTitle);
	DrawPanelItem(Panel_Classes, "Survivors");
	DrawPanelItem(Panel_Classes, "Infected");
	DrawPanelItem(Panel_Classes, "Back");

	SendPanelToClient(Panel_Classes, client, Panel_Classes_Handle, 60);
	CloseHandle(Panel_Classes);
}


public Panel_Classes_Handle(Handle:Panel_Classes, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplaySurvivorsPanel(client);
		}

		if (param2 == 2)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayInfectedPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayMainPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								SURVIVORS PANEL
//============================================================================================================================================================================================================================================





public DisplaySurvivorsPanel(client)
{
	new Handle:Panel_Survivors = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Survivors, sTitle);
	if (IsClassProtector(client)) { DrawPanelItem(Panel_Survivors, "Protector [x]"); } else { DrawPanelItem(Panel_Survivors, "Protector [ ]"); }
	if (IsClassCommando(client)) { DrawPanelItem(Panel_Survivors, "Commando [x]"); } else { DrawPanelItem(Panel_Survivors, "Commando [ ]"); }
	if (IsClassSupport(client)) { DrawPanelItem(Panel_Survivors, "Support [x]"); } else { DrawPanelItem(Panel_Survivors, "Support [ ]"); }
	if (IsClassMedic(client)) { DrawPanelItem(Panel_Survivors, "Medic [x]"); } else { DrawPanelItem(Panel_Survivors, "Medic [ ]"); }
	if (IsClassRecon(client)) { DrawPanelItem(Panel_Survivors, "Recon [x]"); } else { DrawPanelItem(Panel_Survivors, "Recon [ ]"); }
	DrawPanelItem(Panel_Survivors, "Back");

	SendPanelToClient(Panel_Survivors, client, Panel_Survivors_Handle, 60);
	CloseHandle(Panel_Survivors);
}


public Panel_Survivors_Handle(Handle:Panel_Survivors, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			if (!StrEqual(g_sSurvClass[client], "") && !IsClassProtector(client))
			{
				PrintHintText(client, "Deselect a survivor class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (IsClassProtector(client))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (StrEqual(g_sSurvClass[client], ""))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "Protector");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}
		}

		if (param2 == 2)
		{
			if (!StrEqual(g_sSurvClass[client], "") && !IsClassCommando(client))
			{
				PrintHintText(client, "Deselect a survivor class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (IsClassCommando(client))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (StrEqual(g_sSurvClass[client], ""))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "Commando");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}
		}

		if (param2 == 3)
		{
			if (!StrEqual(g_sSurvClass[client], "") && !IsClassSupport(client))
			{
				PrintHintText(client, "Deselect a survivor class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (IsClassSupport(client))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (StrEqual(g_sSurvClass[client], ""))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "Support");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}
		}

		if (param2 == 4)
		{
			if (!StrEqual(g_sSurvClass[client], "") && !IsClassMedic(client))
			{
				PrintHintText(client, "Deselect a survivor class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (IsClassMedic(client))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (StrEqual(g_sSurvClass[client], ""))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "Medic");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}
		}

		if (param2 == 5)
		{
			if (!StrEqual(g_sSurvClass[client], "") && !IsClassRecon(client))
			{
				PrintHintText(client, "Deselect a survivor class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (IsClassRecon(client))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}

			else if (StrEqual(g_sSurvClass[client], ""))
			{
				Format(g_sSurvClass[client], sizeof(g_sSurvClass[]), "Recon");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplaySurvivorsPanel(client);
			}
		}

		if (param2 == 6)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayClassesPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								INFECTED PANEL
//============================================================================================================================================================================================================================================





public DisplayInfectedPanel(client)
{
	new Handle:Panel_Infected = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Infected, sTitle);
	if (StrEqual(g_sInfClassOne[client], "Boomer") || StrEqual(g_sInfClassTwo[client], "Boomer") || StrEqual(g_sInfClassThree[client], "Boomer")) { DrawPanelItem(Panel_Infected, "Boomer [x]"); } else { DrawPanelItem(Panel_Infected, "Boomer [ ]"); }
	if (StrEqual(g_sInfClassOne[client], "Charger") || StrEqual(g_sInfClassTwo[client], "Charger") || StrEqual(g_sInfClassThree[client], "Charger")) { DrawPanelItem(Panel_Infected, "Charger [x]"); } else { DrawPanelItem(Panel_Infected, "Charger [ ]"); }
	if (StrEqual(g_sInfClassOne[client], "Hunter") || StrEqual(g_sInfClassTwo[client], "Hunter") || StrEqual(g_sInfClassThree[client], "Hunter")) { DrawPanelItem(Panel_Infected, "Hunter [x]"); } else { DrawPanelItem(Panel_Infected, "Hunter [ ]"); }
	if (StrEqual(g_sInfClassOne[client], "Jockey") || StrEqual(g_sInfClassTwo[client], "Jockey") || StrEqual(g_sInfClassThree[client], "Jockey")) { DrawPanelItem(Panel_Infected, "Jockey [x]"); } else { DrawPanelItem(Panel_Infected, "Jockey [ ]"); }
	if (StrEqual(g_sInfClassOne[client], "Smoker") || StrEqual(g_sInfClassTwo[client], "Smoker") || StrEqual(g_sInfClassThree[client], "Smoker")) { DrawPanelItem(Panel_Infected, "Smoker [x]"); } else { DrawPanelItem(Panel_Infected, "Smoker [ ]"); }
	if (StrEqual(g_sInfClassOne[client], "Spitter") || StrEqual(g_sInfClassTwo[client], "Spitter") || StrEqual(g_sInfClassThree[client], "Spitter")) { DrawPanelItem(Panel_Infected, "Spitter [x]"); } else { DrawPanelItem(Panel_Infected, "Spitter [ ]"); }
	DrawPanelItem(Panel_Infected, "Back");

	SendPanelToClient(Panel_Infected, client, Panel_Infected_Handle, 60);
	CloseHandle(Panel_Infected);
}


public Panel_Infected_Handle(Handle:Panel_Infected, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			if (!StrEqual(g_sInfClassOne[client], "") && !StrEqual(g_sInfClassTwo[client], "") && !StrEqual(g_sInfClassThree[client], "") && !StrEqual(g_sInfClassOne[client], "Boomer") && !StrEqual(g_sInfClassTwo[client], "Boomer") && !StrEqual(g_sInfClassThree[client], "Boomer"))
			{
				PrintHintText(client, "Deselect an infected class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], "Boomer"))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], "Boomer"))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], "Boomer"))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], ""))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "Boomer");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], ""))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "Boomer");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], ""))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "Boomer");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}
		}

		if (param2 == 2)
		{
			if (!StrEqual(g_sInfClassOne[client], "") && !StrEqual(g_sInfClassTwo[client], "") && !StrEqual(g_sInfClassThree[client], "") && !StrEqual(g_sInfClassOne[client], "Charger") && !StrEqual(g_sInfClassTwo[client], "Charger") && !StrEqual(g_sInfClassThree[client], "Charger"))
			{
				PrintHintText(client, "Deselect an infected class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], "Charger"))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], "Charger"))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], "Charger"))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], ""))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "Charger");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], ""))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "Charger");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], ""))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "Charger");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}
		}

		if (param2 == 3)
		{
			if (!StrEqual(g_sInfClassOne[client], "") && !StrEqual(g_sInfClassTwo[client], "") && !StrEqual(g_sInfClassThree[client], "") && !StrEqual(g_sInfClassOne[client], "Hunter") && !StrEqual(g_sInfClassTwo[client], "Hunter") && !StrEqual(g_sInfClassThree[client], "Hunter"))
			{
				PrintHintText(client, "Deselect an infected class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], "Hunter"))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], "Hunter"))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], "Hunter"))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], ""))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "Hunter");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], ""))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "Hunter");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], ""))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "Hunter");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}
		}

		if (param2 == 4)
		{
			if (!StrEqual(g_sInfClassOne[client], "") && !StrEqual(g_sInfClassTwo[client], "") && !StrEqual(g_sInfClassThree[client], "") && !StrEqual(g_sInfClassOne[client], "Jockey") && !StrEqual(g_sInfClassTwo[client], "Jockey") && !StrEqual(g_sInfClassThree[client], "Jockey"))
			{
				PrintHintText(client, "Deselect an infected class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], "Jockey"))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], "Jockey"))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], "Jockey"))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], ""))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "Jockey");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], ""))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "Jockey");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], ""))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "Jockey");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}
		}

		if (param2 == 5)
		{
			if (!StrEqual(g_sInfClassOne[client], "") && !StrEqual(g_sInfClassTwo[client], "") && !StrEqual(g_sInfClassThree[client], "") && !StrEqual(g_sInfClassOne[client], "Smoker") && !StrEqual(g_sInfClassTwo[client], "Smoker") && !StrEqual(g_sInfClassThree[client], "Smoker"))
			{
				PrintHintText(client, "Deselect an infected class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], "Smoker"))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], "Smoker"))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], "Smoker"))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], ""))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "Smoker");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], ""))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "Smoker");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], ""))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "Smoker");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}
		}

		if (param2 == 6)
		{
			if (!StrEqual(g_sInfClassOne[client], "") && !StrEqual(g_sInfClassTwo[client], "") && !StrEqual(g_sInfClassThree[client], "") && !StrEqual(g_sInfClassOne[client], "Spitter") && !StrEqual(g_sInfClassTwo[client], "Spitter") && !StrEqual(g_sInfClassThree[client], "Spitter"))
			{
				PrintHintText(client, "Deselect an infected class before choosing another!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], "Spitter"))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], "Spitter"))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], "Spitter"))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassOne[client], ""))
			{
				Format(g_sInfClassOne[client], sizeof(g_sInfClassOne[]), "Spitter");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassTwo[client], ""))
			{
				Format(g_sInfClassTwo[client], sizeof(g_sInfClassTwo[]), "Spitter");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}

			else if (StrEqual(g_sInfClassThree[client], ""))
			{
				Format(g_sInfClassThree[client], sizeof(g_sInfClassThree[]), "Spitter");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayInfectedPanel(client);
			}
		}

		if (param2 == 7)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayClassesPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								EQUIPMENT PANEL
//============================================================================================================================================================================================================================================





public DisplayEquipmentPanel(client)
{
	new Handle:Panel_Equipment = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Equipment, sTitle);
	DrawPanelItem(Panel_Equipment, "Primary");
	DrawPanelItem(Panel_Equipment, "Secondary");
	DrawPanelItem(Panel_Equipment, "Throwable");
	DrawPanelItem(Panel_Equipment, "Health");
	DrawPanelItem(Panel_Equipment, "Boost");
	DrawPanelItem(Panel_Equipment, "Back");

	SendPanelToClient(Panel_Equipment, client, Panel_Equipment_Handle, 60);
	CloseHandle(Panel_Equipment);
}


public Panel_Equipment_Handle(Handle:Panel_Equipment, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayPrimaryPanel(client);
		}

		if (param2 == 2)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplaySecondaryPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayThrowablePanel(client);
		}

		if (param2 == 4)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayHealthPanel(client);
		}

		if (param2 == 5)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayBoostPanel(client);
		}

		if (param2 == 6)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayMainPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								PRIMARY PANEL
//============================================================================================================================================================================================================================================





public DisplayPrimaryPanel(client)
{
	new Handle:Panel_Primary = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Primary, sTitle);
	DrawPanelItem(Panel_Primary, "Assault Rifles");
	DrawPanelItem(Panel_Primary, "Sniper Rifles");
	DrawPanelItem(Panel_Primary, "Shotguns");
	DrawPanelItem(Panel_Primary, "Back");

	SendPanelToClient(Panel_Primary, client, Panel_Primary_Handle, 60);
	CloseHandle(Panel_Primary);
}


public Panel_Primary_Handle(Handle:Panel_Primary, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayAssaultRiflePanel(client);
		}

		if (param2 == 2)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplaySniperRiflePanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayShotgunPanel(client);
		}

		if (param2 == 4)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								ASSAULT RIFLE PANEL
//============================================================================================================================================================================================================================================





public DisplayAssaultRiflePanel(client)
{
	new Handle:Panel_AssaultRifle = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_AssaultRifle, sTitle);
	DrawPanelItem(Panel_AssaultRifle, "M-16");
	DrawPanelItem(Panel_AssaultRifle, "SCAR-L");
	DrawPanelItem(Panel_AssaultRifle, "AK-47");
	DrawPanelItem(Panel_AssaultRifle, "SIG SG552");
	DrawPanelItem(Panel_AssaultRifle, "Back");

	SendPanelToClient(Panel_AssaultRifle, client, Panel_AssaultRifle_Handle, 60);
	CloseHandle(Panel_AssaultRifle);
}


public Panel_AssaultRifle_Handle(Handle:Panel_AssaultRifle, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "rifle");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "M-16");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "rifle_desert");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "SCAR-L");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "rifle_ak47");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "AK-47");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 4)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "rifle_sg552");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "SIG SG552");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 5)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayPrimaryPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								SNIPER RIFLE PANEL
//============================================================================================================================================================================================================================================





public DisplaySniperRiflePanel(client)
{
	new Handle:Panel_SniperRifle = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_SniperRifle, sTitle);
	DrawPanelItem(Panel_SniperRifle, "M14");
	DrawPanelItem(Panel_SniperRifle, "MSG90A1");
	DrawPanelItem(Panel_SniperRifle, "Scout");
	DrawPanelItem(Panel_SniperRifle, "AWP");
	DrawPanelItem(Panel_SniperRifle, "Back");

	SendPanelToClient(Panel_SniperRifle, client, Panel_SniperRifle_Handle, 60);
	CloseHandle(Panel_SniperRifle);
}


public Panel_SniperRifle_Handle(Handle:Panel_SniperRifle, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "hunting_rifle");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "M14");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "sniper_military");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "MSG90A1");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "sniper_scout");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "Scout");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 4)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "sniper_awp");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "AWP");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 5)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayPrimaryPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								SHOTGUN PANEL
//============================================================================================================================================================================================================================================





public DisplayShotgunPanel(client)
{
	new Handle:Panel_Shotgun = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Shotgun, sTitle);
	DrawPanelItem(Panel_Shotgun, "M1014");
	DrawPanelItem(Panel_Shotgun, "SPAS-12");
	DrawPanelItem(Panel_Shotgun, "Back");

	SendPanelToClient(Panel_Shotgun, client, Panel_Shotgun_Handle, 60);
	CloseHandle(Panel_Shotgun);
}


public Panel_Shotgun_Handle(Handle:Panel_Shotgun, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "autoshotgun");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "M1014");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sPrimary[client], sizeof(g_sPrimary[]), "shotgun_spas");
			Format(g_sPrimary[client], sizeof(g_sPrimary[]), "SPAS-12");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayPrimaryPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								SECONDARY PANEL
//============================================================================================================================================================================================================================================





public DisplaySecondaryPanel(client)
{
	new Handle:Panel_Secondary = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Secondary, sTitle);
	DrawPanelItem(Panel_Secondary, "Pistols");
	DrawPanelItem(Panel_Secondary, "Melee");
	DrawPanelItem(Panel_Secondary, "Back");

	SendPanelToClient(Panel_Secondary, client, Panel_Secondary_Handle, 60);
	CloseHandle(Panel_Secondary);
}


public Panel_Secondary_Handle(Handle:Panel_Secondary, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayPistolsPanel(client);
		}

		if (param2 == 2)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayMeleePanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								PISTOLS PANEL
//============================================================================================================================================================================================================================================





public DisplayPistolsPanel(client)
{
	new Handle:Panel_Pistols = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Pistols, sTitle);
	DrawPanelItem(Panel_Pistols, "Dual Pistols");
	DrawPanelItem(Panel_Pistols, "Magnum");
	DrawPanelItem(Panel_Pistols, "Back");

	SendPanelToClient(Panel_Pistols, client, Panel_Pistols_Handle, 60);
	CloseHandle(Panel_Pistols);
}


public Panel_Pistols_Handle(Handle:Panel_Pistols, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sSecondary[client], sizeof(g_sSecondary[]), "pistol");
			Format(g_sSecondary[client], sizeof(g_sSecondary[]), "Dual Pistols");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sSecondary[client], sizeof(g_sSecondary[]), "pistol_magnum");
			Format(g_sSecondary[client], sizeof(g_sSecondary[]), "Magnum");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplaySecondaryPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								MELEE PANEL
//============================================================================================================================================================================================================================================





public DisplayMeleePanel(client)
{
	new Handle:Panel_Melee = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Melee, sTitle);
	DrawPanelItem(Panel_Melee, "Katana");
	DrawPanelItem(Panel_Melee, "Machete");
	DrawPanelItem(Panel_Melee, "Baseball Bat");
	DrawPanelItem(Panel_Melee, "Frying Pan");
	DrawPanelItem(Panel_Melee, "Chainsaw");
	DrawPanelItem(Panel_Melee, "Back");

	SendPanelToClient(Panel_Melee, client, Panel_Melee_Handle, 60);
	CloseHandle(Panel_Melee);
}


public Panel_Melee_Handle(Handle:Panel_Melee, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sSecondary[client], sizeof(g_sSecondary[]), "katana");
			Format(g_sSecondary[client], sizeof(g_sSecondary[]), "Katana");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sSecondary[client], sizeof(g_sSecondary[]), "machete");
			Format(g_sSecondary[client], sizeof(g_sSecondary[]), "Machete");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			//Format(g_sSecondary[client], sizeof(g_sSecondary[]), "baseball_bat");
			Format(g_sSecondary[client], sizeof(g_sSecondary[]), "Baseball Bat");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 4)
		{
			//Format(g_sSecondary[client], sizeof(g_sSecondary[]), "frying_pan");
			Format(g_sSecondary[client], sizeof(g_sSecondary[]), "Frying Pan");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 5)
		{
			//Format(g_sSecondary[client], sizeof(g_sSecondary[]), "chainsaw");
			Format(g_sSecondary[client], sizeof(g_sSecondary[]), "Chainsaw");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 6)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplaySecondaryPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								THROWABLE PANEL
//============================================================================================================================================================================================================================================





public DisplayThrowablePanel(client)
{
	new Handle:Panel_Throwable = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Throwable, sTitle);
	DrawPanelItem(Panel_Throwable, "Pipe Bomb");
	DrawPanelItem(Panel_Throwable, "Molotov");
	DrawPanelItem(Panel_Throwable, "Bile");
	DrawPanelItem(Panel_Throwable, "Back");

	SendPanelToClient(Panel_Throwable, client, Panel_Throwable_Handle, 60);
	CloseHandle(Panel_Throwable);
}


public Panel_Throwable_Handle(Handle:Panel_Throwable, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sGrenade[client], sizeof(g_sGrenade[]), "pipe_bomb");
			Format(g_sGrenade[client], sizeof(g_sGrenade[]), "Pipe Bomb");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sGrenade[client], sizeof(g_sGrenade[]), "molotov");
			Format(g_sGrenade[client], sizeof(g_sGrenade[]), "Molotov");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			//Format(g_sGrenade[client], sizeof(g_sGrenade[]), "vomitjar");
			Format(g_sGrenade[client], sizeof(g_sGrenade[]), "Bile");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 4)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								HEALTH PANEL
//============================================================================================================================================================================================================================================





public DisplayHealthPanel(client)
{
	new Handle:Panel_Health = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Health, sTitle);
	DrawPanelItem(Panel_Health, "First Aid Kit");
	DrawPanelItem(Panel_Health, "Defibrillator");
	DrawPanelItem(Panel_Health, "Back");

	SendPanelToClient(Panel_Health, client, Panel_Health_Handle, 60);
	CloseHandle(Panel_Health);
}


public Panel_Health_Handle(Handle:Panel_Health, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sHealth[client], sizeof(g_sHealth[]), "first_aid_kit");
			Format(g_sHealth[client], sizeof(g_sHealth[]), "First Aid Kit");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sHealth[client], sizeof(g_sHealth[]), "defibrillator");
			Format(g_sHealth[client], sizeof(g_sHealth[]), "Defibrillator");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								BOOST PANEL
//============================================================================================================================================================================================================================================





public DisplayBoostPanel(client)
{
	new Handle:Panel_Boost = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Boost, sTitle);
	DrawPanelItem(Panel_Boost, "Pills");
	DrawPanelItem(Panel_Boost, "Adrenaline");
	DrawPanelItem(Panel_Boost, "Back");

	SendPanelToClient(Panel_Boost, client, Panel_Boost_Handle, 60);
	CloseHandle(Panel_Boost);
}


public Panel_Boost_Handle(Handle:Panel_Boost, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			//Format(g_sBoost[client], sizeof(g_sBoost[]), "pain_pills");
			Format(g_sBoost[client], sizeof(g_sBoost[]), "Pills");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 2)
		{
			//Format(g_sBoost[client], sizeof(g_sBoost[]), "adrenaline");
			Format(g_sBoost[client], sizeof(g_sBoost[]), "Adrenaline");
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayEquipmentPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								OPTIONS PANEL
//============================================================================================================================================================================================================================================





public DisplayOptionsPanel(client)
{
	new Handle:Panel_Options = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Options, sTitle);
	DrawPanelItem(Panel_Options, "Stats");
	DrawPanelItem(Panel_Options, "Teams");
	DrawPanelItem(Panel_Options, "Back");

	SendPanelToClient(Panel_Options, client, Panel_Options_Handle, 60);
	CloseHandle(Panel_Options);
}


public Panel_Options_Handle(Handle:Panel_Options, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			g_bStatsPanel[client] = true;
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayStatsPanel(client);
		}

		if (param2 == 2)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayTeamsPanel(client);
		}

		if (param2 == 3)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayMainPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								STATS PANEL
//============================================================================================================================================================================================================================================





public DisplayStatsPanel(client)
{
	new Handle:Panel_Stats = CreatePanel();
	new String:sTitle[512];

	new iRawTime = g_iTimePlayed[client] + RoundToZero(GetClientTime(client));
	new iHours = (iRawTime / 3600);
	new iMinutes = ((iRawTime % 3600) / 60);
	new iSeconds = ((iRawTime % 3600) % 60);
	new String:sTimePlayed[256];
	if (iHours > 0) { Format(sTimePlayed, sizeof(sTimePlayed), "%dh %dm %ds", iHours, iMinutes, iSeconds); }
	else if (iMinutes > 0) { Format(sTimePlayed, sizeof(sTimePlayed), "%dm %ds", iMinutes, iSeconds); }
	else { Format(sTimePlayed, sizeof(sTimePlayed), "%ds", iSeconds); }

	iRawTime = GetTime() - g_iLastConnected[client];
	iHours = (iRawTime / 3600);
	iMinutes = ((iRawTime % 3600) / 60);
	iSeconds = ((iRawTime % 3600) % 60);
	new String:sLastSession[256];
	if (g_iLastConnected[client] > 0)
	{
		if (iHours > 0) { Format(sLastSession, sizeof(sLastSession), "%dh %dm %ds ago", iHours, iMinutes, iSeconds); }
		else if (iMinutes > 0) { Format(sLastSession, sizeof(sLastSession), "%dm %ds ago", iMinutes, iSeconds); }
		else { Format(sLastSession, sizeof(sLastSession), "%ds ago", iSeconds); }
	}

	else { Format(sLastSession, sizeof(sLastSession), "Never"); Format(g_sLastServer[client], sizeof(g_sLastServer[]), "None"); }

	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n                 GENERAL\n \nTotal Time: %s \nLast Played: %s \nLast Server: %s \n \n               SURVIVORS\n \nCommon: %d \nSpecials: %d \nTanks: %d \nWitches: %d \nIncaps: %d \nDeaths: %d \n \n                INFECTED\n \nDamage: %d \nIncaps: %d \nKills: %d \nDeaths: %d \n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, sTimePlayed, sLastSession, g_sLastServer[client], g_iSurvivorCommonKills[client], g_iSurvivorSpecialKills[client], g_iSurvivorTankKills[client], g_iSurvivorWitchKills[client], g_iSurvivorSurvivorIncaps[client], g_iSurvivorSurvivorDeaths[client], g_iInfectedSurvivorDamage[client], g_iInfectedSurvivorIncaps[client], g_iInfectedSurvivorKills[client], g_iInfectedSpecialDeaths[client]);
	SetPanelTitle(Panel_Stats, sTitle);
	DrawPanelItem(Panel_Stats, "Back");


	SendPanelToClient(Panel_Stats, client, Panel_Stats_Handle, 1);

	if (g_bStatsPanel[client])
	{
		CreateTimer(1.0, Timer_Stats, client);
	}

	CloseHandle(Panel_Stats);
}


public Panel_Stats_Handle(Handle:Panel_Stats, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			g_bStatsPanel[client] = false;
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayOptionsPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								TEAMS PANEL
//============================================================================================================================================================================================================================================





public DisplayTeamsPanel(client)
{
	new Handle:Panel_Teams = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Teams, sTitle);
	DrawPanelItem(Panel_Teams, "Spectator");
	DrawPanelItem(Panel_Teams, "Survivors");
	DrawPanelItem(Panel_Teams, "Infected");
	DrawPanelItem(Panel_Teams, "Back");

	SendPanelToClient(Panel_Teams, client, Panel_Teams_Handle, 60);
	CloseHandle(Panel_Teams);
}


public Panel_Teams_Handle(Handle:Panel_Teams, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			if (IsPlayerSpectator(client))
			{
				PrintHintText(client, "You are already on that team!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayTeamsPanel(client);
				return;
			}

			ChangeClientTeam(client, 1);
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayTeamsPanel(client);
			return;
		}

		if (param2 == 2)
		{
			if (IsPlayerSurvivor(client))
			{
				PrintHintText(client, "You are already on that team!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayTeamsPanel(client);
				return;
			}

			new iCount;
			new iLimit = GetConVarInt(FindConVar("survivor_limit"));

			for (new x = 1; x <= MaxClients; x++)
			{
				if (IsClientInGame(x) && !IsFakeClient(x) && IsPlayerSurvivor(x))
				{
					iCount++;
				}
			}

			if (iCount >= iLimit)
			{
				PrintHintText(client, "That team is currently full!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayTeamsPanel(client);
				return;
			}

			ChangeClientTeam(client, 1);

			for (new x = 1; x <= MaxClients; x++)
			{
				if (IsClientInGame(x) && IsFakeClient(x) && IsPlayerSurvivor(x))
				{
					SDKCall(g_hSetHumanSpec, x, client);
					SDKCall(g_hTakeOverBot, client, true);
					EmitSoundToClient(client, SOUND_MENU_SELECT);
					DisplayTeamsPanel(client);
					return;
				}
			}

			return;
		}

		if (param2 == 3)
		{
			if (IsPlayerInfected(client))
			{
				PrintHintText(client, "You are already on that team!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayTeamsPanel(client);
				return;
			}

			new iCount;
			new iLimit = GetConVarInt(FindConVar("z_max_player_zombies"));

			for (new x = 1; x <= MaxClients; x++)
			{
				if (IsClientInGame(x) && !IsFakeClient(x) && IsPlayerInfected(x))
				{
					iCount++;
				}
			}

			if (iCount >= iLimit)
			{
				PrintHintText(client, "That team is currently full!");
				EmitSoundToClient(client, SOUND_MENU_SELECT);
				DisplayTeamsPanel(client);
				return;
			}

			ChangeClientTeam(client, 3);
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayTeamsPanel(client);
			return;
		}

		if (param2 == 4)
		{
			EmitSoundToClient(client, SOUND_MENU_SELECT);
			DisplayOptionsPanel(client);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								MEDIC PANEL
//============================================================================================================================================================================================================================================





public DisplayMedicPanel(client)
{
	new Handle:Panel_Medic = CreatePanel();
	new String:sTitle[512];
	Format(sTitle, sizeof(sTitle), "             %s (v%s)\n_______________________________\n \n               SURVIVORS\n \nClass: %s\nPrimary: %s\nSecondary: %s\nThrowable: %s\nHealth: %s\nBoost: %s\n \n                INFECTED\n \nClass 1: %s\nClass 2: %s\nClass 3: %s\n_______________________________\n ", PLUGIN_NAME, PLUGIN_VERSION, g_sSurvClass[client], g_sPrimary[client], g_sSecondary[client], g_sGrenade[client], g_sHealth[client], g_sBoost[client], g_sInfClassOne[client], g_sInfClassTwo[client], g_sInfClassThree[client]);
	SetPanelTitle(Panel_Medic, sTitle);
	DrawPanelItem(Panel_Medic, "Heal (1 bind)");
	DrawPanelItem(Panel_Medic, "Revive (2 binds)");
	DrawPanelItem(Panel_Medic, "Resurrect (3 binds)");

	SendPanelToClient(Panel_Medic, client, Panel_Medic_Handle, 60);
	CloseHandle(Panel_Medic);
}


public Panel_Medic_Handle(Handle:Panel_Medic, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			MedicHeal(client);
			EmitSoundToClient(client, SOUND_MENU_SELECT);
		}

		if (param2 == 2)
		{
			if (g_iBindTwoUses[client] < 2)
			{
				PrintHintText(client, "You don't have enough bind 2 uses for that!");
				return;
			}

			MedicRevive(client);
			EmitSoundToClient(client, SOUND_MENU_SELECT);
		}

		if (param2 == 3)
		{
			if (g_iBindTwoUses[client] < 3)
			{
				PrintHintText(client, "You don't have enough bind 2 uses for that!");
				return;
			}

			MedicResurrect(client);
			EmitSoundToClient(client, SOUND_MENU_SELECT);
		}
	}

	if (action == MenuAction_End)
	{
		return;
	}
}





//============================================================================================================================================================================================================================================
//																								CUSTOM FUNCTIONS
//============================================================================================================================================================================================================================================





ApplyColor(client)
{
	if (IsPlayerSurvivor(client) && IsPlayerConfirmed(client))
	{
		if (IsClassProtector(client))
		{
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 200, 0, 255);
		}

		if (IsClassCommando(client))
		{
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 0, 0, 255);
		}

		else if (IsClassSupport(client))
		{
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 255, 255, 64);
		}

		else if (IsClassMedic(client))
		{
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 64, 255, 0, 255);
		}

		else if (IsClassRecon(client))
		{
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 64, 64, 255, 255);
		}
	}

	else if (IsPlayerInfected(client) && IsPlayerConfirmed(client))
	{
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client, 255, 255, 255, 255);
	}
}

ResetColor(client)
{
	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, 255, 255, 255, 255);
}

ApplyHealth(client, bot)
{
	new iRealHealth = GetClientHealth(client);
	new iMaxHealth = GetEntProp(bot, Prop_Send, "m_iMaxHealth");
	new Float:fHealthRatio = FloatDiv(float(iRealHealth), float(iMaxHealth));

	if (IsPlayerSurvivor(client) && IsPlayerConfirmed(client))
	{
		if (IsClassProtector(client))
		{
			new iNew = RoundToCeil(FloatMul(float(300), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 300);
		}

		else if (IsClassCommando(client))
		{
			new iNew = RoundToCeil(FloatMul(float(100), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 100);
		}

		else if (IsClassSupport(client))
		{
			new iNew = RoundToCeil(FloatMul(float(200), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 200);
		}

		else if (IsClassMedic(client))
		{
			new iNew = RoundToCeil(FloatMul(float(100), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 100);
		}

		else if (IsClassRecon(client))
		{
			new iNew = RoundToCeil(FloatMul(float(150), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 150);
		}
	}

	else if (IsPlayerInfected(client) && IsPlayerConfirmed(client))
	{
		if (IsPlayerBoomer(client) && IsClassBoomer(client))
		{
			new iNew = RoundToCeil(FloatMul(float(50), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 50);
		}

		else if (IsPlayerCharger(client) && IsClassCharger(client))
		{
			new iNew = RoundToCeil(FloatMul(float(850), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 850);
		}

		else if (IsPlayerHunter(client) && IsClassHunter(client))
		{
			new iNew = RoundToCeil(FloatMul(float(500), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 500);
		}

		else if (IsPlayerJockey(client) && IsClassJockey(client))
		{
			new iNew = RoundToCeil(FloatMul(float(650), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 650);
		}

		else if (IsPlayerSmoker(client) && IsClassSmoker(client))
		{
			new iNew = RoundToCeil(FloatMul(float(250), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 250);
		}

		else if (IsPlayerSpitter(client) && IsClassSpitter(client))
		{
			new iNew = RoundToCeil(FloatMul(float(100), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 100);
		}

		else if (IsPlayerTank(client))
		{
			new iNew = RoundToCeil(FloatMul(float(10000), fHealthRatio));
			SetEntityHealth(client, iNew);
			SetEntProp(client, Prop_Send, "m_iHealth", iNew);
			SetEntProp(client, Prop_Send, "m_iMaxHealth", 10000);
		}
	}
}

ResetHealth(client, bot)
{
	new iRealHealth = GetClientHealth(client);
	new iMaxHealth = GetEntProp(client, Prop_Send, "m_iMaxHealth");
	new Float:fHealthRatio = FloatDiv(float(iRealHealth), float(iMaxHealth));

	if (IsFakeClient(bot))
	{
		if (IsPlayerSurvivor(bot))
		{
			new iNew = RoundToCeil(FloatMul(float(100), fHealthRatio));
			SetEntityHealth(bot, iNew);
			SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
			SetEntProp(bot, Prop_Send, "m_iMaxHealth", 100);
		}

		else if (IsPlayerInfected(bot))
		{
			if (IsPlayerBoomer(bot))
			{
				new iNew = RoundToCeil(FloatMul(float(50), fHealthRatio));
				SetEntityHealth(bot, iNew);
				SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
				SetEntProp(bot, Prop_Send, "m_iMaxHealth", 50);
			}

			else if (IsPlayerCharger(bot))
			{
				new iNew = RoundToCeil(FloatMul(float(600), fHealthRatio));
				SetEntityHealth(bot, iNew);
				SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
				SetEntProp(bot, Prop_Send, "m_iMaxHealth", 600);
			}

			else if (IsPlayerHunter(bot))
			{
				new iNew = RoundToCeil(FloatMul(float(250), fHealthRatio));
				SetEntityHealth(bot, iNew);
				SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
				SetEntProp(bot, Prop_Send, "m_iMaxHealth", 250);
			}

			else if (IsPlayerJockey(bot))
			{
				new iNew = RoundToCeil(FloatMul(float(325), fHealthRatio));
				SetEntityHealth(bot, iNew);
				SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
				SetEntProp(bot, Prop_Send, "m_iMaxHealth", 325);
			}

			else if (IsPlayerSmoker(bot))
			{
				new iNew = RoundToCeil(FloatMul(float(250), fHealthRatio));
				SetEntityHealth(bot, iNew);
				SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
				SetEntProp(bot, Prop_Send, "m_iMaxHealth", 250);
			}

			else if (IsPlayerSpitter(bot))
			{
				new iNew = RoundToCeil(FloatMul(float(100), fHealthRatio));
				SetEntityHealth(bot, iNew);
				SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
				SetEntProp(bot, Prop_Send, "m_iMaxHealth", 100);
			}

			else if (IsPlayerTank(bot))
			{
				new iNew = RoundToCeil(FloatMul(float(4000), fHealthRatio));
				SetEntityHealth(bot, iNew);
				SetEntProp(bot, Prop_Send, "m_iHealth", iNew);
				SetEntProp(bot, Prop_Send, "m_iMaxHealth", 4000);
			}
		}
	}
}

ApplySpeed(client)
{
	if (IsPlayerSurvivor(client) && IsPlayerConfirmed(client))
	{
		if (IsClassProtector(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 0.80);
		}

		else if (IsClassCommando(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.1);
		}

		else if (IsClassSupport(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
		}

		else if (IsClassMedic(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.1);
		}

		else if (IsClassRecon(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
		}
	}

	else if (IsPlayerInfected(client) && IsPlayerConfirmed(client))
	{
		if (IsPlayerBoomer(client) && IsClassBoomer(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
		}

		else if (IsPlayerCharger(client) && IsClassCharger(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.3);
		}

		else if (IsPlayerHunter(client) && IsClassHunter(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 2.0);
		}

		else if (IsPlayerJockey(client) && IsClassJockey(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.7);
		}

		else if (IsPlayerSmoker(client) && IsClassSmoker(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.2);
		}

		else if (IsPlayerSpitter(client) && IsClassSpitter(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
		}

		else if (IsPlayerSpitter(client) && IsClassSpitter(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
		}

		else if (IsPlayerTank(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.5);
		}
	}
}

ResetSpeed(client)
{
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
}

ApplyCvars(client)
{
	if (IsPlayerSurvivor(client) && IsPlayerConfirmed(client))
	{
		if (IsClassProtector(client))
		{

		}

		else if (IsClassCommando(client))
		{

		}

		else if (IsClassSupport(client))
		{
			SetConVarInt(g_hAllowCrawling, 1);
			SetConVarInt(g_hCrawlSpeed, 35);
		}

		else if (IsClassMedic(client))
		{

		}

		else if (IsClassRecon(client))
		{

		}
	}

	if (IsPlayerInfected(client) && IsPlayerConfirmed(client))
	{
		if (IsPlayerBoomer(client) && IsClassBoomer(client))
		{
			SetConVarInt(FindConVar("z_vomit_fatigue"), 0);
			SetConVarInt(FindConVar("z_vomit_interval"), 10);
		}

		else if (IsPlayerCharger(client) && IsClassCharger(client))
		{
			SetConVarInt(FindConVar("z_charge_interval"), 7);
		}

		else if (IsPlayerHunter(client) && IsClassHunter(client))
		{

		}

		else if (IsPlayerJockey(client) && IsClassJockey(client))
		{
			SetConVarFloat(FindConVar("z_leap_interval"), 0.15);
			SetConVarInt(FindConVar("z_leap_interval_post_incap"), 15);
			SetConVarInt(FindConVar("z_leap_interval_post_ride"), 3);
			SetConVarInt(FindConVar("z_leap_power"), 640);
		}

		else if (IsPlayerSmoker(client) && IsClassSmoker(client))
		{
			SetConVarFloat(FindConVar("tongue_range"), FloatMul(GetConVarFloat(FindConVar("tongue_range")), 2.6));
			SetConVarFloat(FindConVar("tongue_fly_speed"), FloatMul(GetConVarFloat(FindConVar("tongue_fly_speed")), 1.3));
			SetConVarInt(FindConVar("tongue_hit_delay"), 5);
			SetConVarInt(FindConVar("tongue_miss_delay"), 2);
		}

		else if (IsPlayerSpitter(client) && IsClassSpitter(client))
		{
			SetConVarInt(FindConVar("z_spit_interval"), 15);
		}

		else if (IsPlayerTank(client))
		{
			SetConVarInt(FindConVar("z_frustration"), 0);
			SetConVarFloat(FindConVar("z_tank_attack_interval"), 0.8);
			SetConVarFloat(FindConVar("tank_swing_interval"), 0.8);
			SetConVarFloat(FindConVar("tank_swing_fast_interval"), 0.5);
			SetConVarFloat(FindConVar("tank_swing_miss_interval"), 0.7);
			SetConVarInt(FindConVar("z_tank_throw_interval"), 3);
			SetConVarInt(FindConVar("tank_throw_min_interval"), 3);
		}
	}
}

ResetCvars(client)
{
	if (IsPlayerSurvivor(client) && IsPlayerConfirmed(client))
	{
		if (IsClassProtector(client))
		{

		}

		if (IsClassCommando(client))
		{

		}

		else if (IsClassSupport(client))
		{
			ResetConVar(g_hAllowCrawling);
			ResetConVar(g_hCrawlSpeed);
		}

		else if (IsClassMedic(client))
		{

		}

		else if (IsClassRecon(client))
		{

		}
	}

	if (IsPlayerInfected(client) && IsPlayerConfirmed(client))
	{
		if (IsPlayerBoomer(client) && IsClassBoomer(client))
		{
			ResetConVar(FindConVar("z_vomit_fatigue"));
			ResetConVar(FindConVar("z_vomit_interval"));

		}

		else if (IsPlayerCharger(client) && IsClassCharger(client))
		{
			ResetConVar(FindConVar("z_charge_interval"));
		}

		else if (IsPlayerHunter(client) && IsClassHunter(client))
		{

		}

		else if (IsPlayerJockey(client) && IsClassJockey(client))
		{
			ResetConVar(FindConVar("z_leap_interval"));
			ResetConVar(FindConVar("z_leap_interval_post_incap"));
			ResetConVar(FindConVar("z_leap_interval_post_ride"));
			ResetConVar(FindConVar("z_leap_power"));
		}

		else if (IsPlayerSmoker(client) && IsClassSmoker(client))
		{
			ResetConVar(FindConVar("tongue_range"));
			ResetConVar(FindConVar("tongue_fly_speed"));
			ResetConVar(FindConVar("tongue_hit_delay"));
			ResetConVar(FindConVar("tongue_miss_delay"));
		}

		else if (IsPlayerSpitter(client) && IsClassSpitter(client))
		{
			ResetConVar(FindConVar("z_spit_interval"));
		}

		else if (IsPlayerTank(client))
		{
			ResetConVar(FindConVar("z_frustration"));
			ResetConVar(FindConVar("z_tank_attack_interval"));
			ResetConVar(FindConVar("tank_swing_interval"));
			ResetConVar(FindConVar("tank_swing_fast_interval"));
			ResetConVar(FindConVar("tank_swing_miss_interval"));
			ResetConVar(FindConVar("z_tank_throw_interval"));
			ResetConVar(FindConVar("tank_throw_min_interval"));
		}
	}
}

GiveEquipment(client)
{
	new String:sPrimaryRaw[64];
	new String:sSecondaryRaw[64];
	new String:sGrenadeRaw[64];
	new String:sHealthRaw[64];
	new String:sBoostRaw[64];

	if (StrEqual(g_sPrimary[client], "M-16", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "rifle");
	}

	if (StrEqual(g_sPrimary[client], "SCAR-L", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "rifle_desert");
	}

	if (StrEqual(g_sPrimary[client], "AK-47", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "rifle_ak47");
	}

	if (StrEqual(g_sPrimary[client], "SIG SG552", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "rifle_sg522");
	}


	if (StrEqual(g_sPrimary[client], "M14", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "hunting_rifle");
	}


	if (StrEqual(g_sPrimary[client], "MSG90A1", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "sniper_military");
	}


	if (StrEqual(g_sPrimary[client], "Scout", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "sniper_scout");
	}


	if (StrEqual(g_sPrimary[client], "AWP", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "sniper_awp");
	}


	if (StrEqual(g_sPrimary[client], "M1014", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "autoshotgun");
	}


	if (StrEqual(g_sPrimary[client], "SPAS-12", true))
	{
		strcopy(sPrimaryRaw, sizeof(sPrimaryRaw), "shotgun_spas");
	}


	if (StrEqual(g_sSecondary[client], "Dual Pistols", true))
	{
		strcopy(sSecondaryRaw, sizeof(sSecondaryRaw), "pistol");
	}


	if (StrEqual(g_sSecondary[client], "Magnum", true))
	{
		strcopy(sSecondaryRaw, sizeof(sSecondaryRaw), "pistol_magnum");
	}


	if (StrEqual(g_sSecondary[client], "Katana", true))
	{
		strcopy(sSecondaryRaw, sizeof(sSecondaryRaw), "katana");
	}


	if (StrEqual(g_sSecondary[client], "Machete", true))
	{
		strcopy(sSecondaryRaw, sizeof(sSecondaryRaw), "machete");
	}


	if (StrEqual(g_sSecondary[client], "Baseball Bat", true))
	{
		strcopy(sSecondaryRaw, sizeof(sSecondaryRaw), "baseball_bat");
	}


	if (StrEqual(g_sSecondary[client], "Frying Pan", true))
	{
		strcopy(sSecondaryRaw, sizeof(sSecondaryRaw), "frying_pan");
	}


	if (StrEqual(g_sSecondary[client], "Chainsaw", true))
	{
		strcopy(sSecondaryRaw, sizeof(sSecondaryRaw), "chainsaw");
	}


	if (StrEqual(g_sGrenade[client], "Pipe Bomb", true))
	{
		strcopy(sGrenadeRaw, sizeof(sGrenadeRaw), "pipe_bomb");
	}


	if (StrEqual(g_sGrenade[client], "Molotov", true))
	{
		strcopy(sGrenadeRaw, sizeof(sGrenadeRaw), "molotov");
	}


	if (StrEqual(g_sGrenade[client], "Bile", true))
	{
		strcopy(sGrenadeRaw, sizeof(sGrenadeRaw), "vomitjar");
	}


	if (StrEqual(g_sHealth[client], "First Aid Kit", true))
	{
		strcopy(sHealthRaw, sizeof(sHealthRaw), "first_aid_kit");
	}


	if (StrEqual(g_sHealth[client], "Defibrillator", true))
	{
		strcopy(sHealthRaw, sizeof(sHealthRaw), "defibrillator");
	}


	if (StrEqual(g_sBoost[client], "Pills", true))
	{
		strcopy(sBoostRaw, sizeof(sBoostRaw), "pain_pills");
	}


	if (StrEqual(g_sBoost[client], "Adrenaline", true))
	{
		strcopy(sBoostRaw, sizeof(sBoostRaw), "adrenaline");
	}

	new flags = GetCommandFlags("give");
	SetCommandFlags("give", flags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "give %s", sPrimaryRaw);
	FakeClientCommand(client, "give %s", sSecondaryRaw);
	FakeClientCommand(client, "give %s", sGrenadeRaw);
	FakeClientCommand(client, "give %s", sHealthRaw);
	FakeClientCommand(client, "give %s", sBoostRaw);
	SetCommandFlags("give", flags|FCVAR_CHEAT);

	flags = GetCommandFlags("upgrade_add");
	SetCommandFlags("upgrade_add", flags & ~FCVAR_CHEAT);
	FakeClientCommand(client, "upgrade_add LASER_SIGHT");
	SetCommandFlags("upgrade_add", flags|FCVAR_CHEAT);
}

ApplyDamage(attacker, victim, amount)
{
	decl Float:victimPos[3], String:strAmount[16], String:strAmountTarget[16];

	GetClientEyePosition(victim, victimPos);
	IntToString(amount, strAmount, sizeof(strAmount));
	Format(strAmountTarget, sizeof(strAmountTarget), "hurtme%d", victim);

	new entPointHurt = CreateEntityByName("point_hurt");
	if(!entPointHurt) return;

	// Config, create point_hurt
	DispatchKeyValue(victim, "targetname", strAmountTarget);
	DispatchKeyValue(entPointHurt, "DamageTarget", strAmountTarget);
	DispatchKeyValue(entPointHurt, "Damage", strAmount);
	DispatchKeyValue(entPointHurt, "DamageType", "0"); // DMG_GENERIC
	DispatchSpawn(entPointHurt);

	// Teleport, activate point_hurt
	TeleportEntity(entPointHurt, victimPos, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(entPointHurt, "Hurt", (attacker && attacker < MaxClients && IsClientInGame(attacker)) ? attacker : -1);

	// Config, delete point_hurt
	DispatchKeyValue(entPointHurt, "classname", "point_hurt");
	DispatchKeyValue(victim, "targetname", "null");
	RemoveEdict(entPointHurt);
}

MedicAOE(client)
{
	new Float:clientPos[3];
	GetClientAbsOrigin(client, clientPos);

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && client != x)
		{
			new Float:xPos[3];
			GetClientAbsOrigin(x, xPos);

			if (GetVectorDistance(clientPos, xPos) <= 256)
			{

				new iMaxHealth = GetEntProp(x, Prop_Data, "m_iMaxHealth");
				new iHealth = GetClientHealth(x);

				if (iHealth/iMaxHealth < 1.0)
				{
					new iRandom = GetRandomInt(1, 3);

					if (iRandom == 1)
					{
						EmitSoundToAll(SOUND_MEDIC_AOE1, client);
					}

					if (iRandom == 2)
					{
						EmitSoundToAll(SOUND_MEDIC_AOE2, client);
					}

					if (iRandom == 3)
					{
						EmitSoundToAll(SOUND_MEDIC_AOE3, client);
					}

					SetEntityHealth(x, iHealth + 1);
				}
			}
		}
	}
}

MedicGamble(client)
{
	new iGamble = GetRandomInt(1, 6);

	if (iGamble == 1)
	{
		new flags = GetCommandFlags("give");
		SetCommandFlags("give", flags & ~FCVAR_CHEAT);
		FakeClientCommand(client, "give health");
		SetCommandFlags("give", flags|FCVAR_CHEAT);
		PrintHintText(client, "You have received a divine intervention!");
	}

	if (iGamble == 2)
	{
		new iDamage = GetRandomInt(25, 75);
		new iHealth = GetClientHealth(client);

		if (iDamage >= iHealth)
		{
			SlapPlayer(client, iHealth - 1);
			PrintHintText(client, "You were slapped for %d damage!", iHealth - 1);
		}

		else
		{
			SlapPlayer(client, iDamage);
			PrintHintText(client, "You were slapped for %d damage!", iDamage);
		}
	}

	if (iGamble == 3)
	{
		new flags = GetCommandFlags("give");
		SetCommandFlags("give", flags & ~FCVAR_CHEAT);
		FakeClientCommand(client, "give pain_pills");
		FakeClientCommand(client, "give pain_pills");
		FakeClientCommand(client, "give pain_pills");
		FakeClientCommand(client, "give pain_pills");
		SetCommandFlags("give", flags|FCVAR_CHEAT);
		PrintHintText(client, "You have found a stash of pills!");
	}

	if (iGamble == 4)
	{
		Blind(client, 30);
		PrintHintText(client, "A bad trip has blinded you for 30 seconds!");
	}

	if (iGamble == 5)
	{
		new flags = GetCommandFlags("give");
		SetCommandFlags("give", flags & ~FCVAR_CHEAT);
		FakeClientCommand(client, "give first_aid_kit");
		FakeClientCommand(client, "give defibrillator");
		FakeClientCommand(client, "give pain_pills");
		FakeClientCommand(client, "give adrenaline");
		SetCommandFlags("give", flags|FCVAR_CHEAT);
		PrintHintText(client, "You have raided a medicine cabinet!");
	}

	if (iGamble == 6)
	{
		RemovePrimaryWeapon(client);
		PrintHintText(client, "Your weapon was stolen while searching for supplies!");
	}
}

MedicHeal(client)
{
	new bool:bHealed;

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && IsPlayerAlive(x) && !IsPlayerIncapped(x))
		{
			new iMaxHealth = GetEntProp(x, Prop_Data, "m_iMaxHealth");
			new iHealth = GetClientHealth(x);

			if (iHealth < iMaxHealth)
			{
				bHealed = true;

				if (iHealth + 20 > iMaxHealth)
				{
					SetEntityHealth(x, iMaxHealth);

				}

				else
				{
					SetEntityHealth(x, iHealth + 20);
				}
			}
		}
	}

	if (bHealed)
	{
		g_iBindTwoUses[client]--;
	}

	else
	{
		PrintHintText(client, "No survivors need healing!");
	}
}

MedicRevive(client)
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && IsPlayerAlive(x) && IsPlayerIncapped(x))
		{
			new flags = GetCommandFlags("give");
			SetCommandFlags("give", flags & ~FCVAR_CHEAT);
			FakeClientCommand(x, "give health");
			SetCommandFlags("give", flags|FCVAR_CHEAT);

			SetEntityHealth(x, 0);
			SetEntPropFloat(x, Prop_Send, "m_healthBufferTime", GetGameTime());
			SetEntPropFloat(x, Prop_Send, "m_healthBuffer", 30.0);

			g_iBindTwoUses[client]--;
			g_iBindTwoUses[client]--;

			return;
		}
	}

	PrintHintText(client, "No survivors are incapped!");
	DisplayMedicPanel(client);
}

MedicResurrect(client)
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && !IsPlayerAlive(x))
		{
			new Float:clientPos[3];
			GetClientAbsOrigin(client, clientPos);

			SDKCall(g_hRoundRespawn, x);
			TeleportEntity(x, clientPos, NULL_VECTOR, NULL_VECTOR);

			g_iBindTwoUses[client]--;
			g_iBindTwoUses[client]--;
			g_iBindTwoUses[client]--;

			return;
		}
	}

	PrintHintText(client, "No survivors are dead!");
	DisplayMedicPanel(client);
}

SupportAOE(client)
{
	new Float:clientPos[3];
	GetClientAbsOrigin(client, clientPos);
	new iNearClient = GetNearestClient(client);
	new Float:nearestPos[3];
	GetClientAbsOrigin(iNearClient, nearestPos);

	if (GetVectorDistance(clientPos, nearestPos) <= 1536)
	{
		new iMaxHealth = GetEntProp(iNearClient, Prop_Data, "m_iMaxHealth");
		new iHealth = GetClientHealth(iNearClient);

		if (iHealth/iMaxHealth < 1.0)
		{
			new iRandom = GetRandomInt(1, 3);

			if (iRandom == 1)
			{
				EmitSoundToAll(SOUND_SUPPORT_AOE1, client);
			}

			if (iRandom == 2)
			{
				EmitSoundToAll(SOUND_SUPPORT_AOE2, client);
			}

			if (iRandom == 3)
			{
				EmitSoundToAll(SOUND_SUPPORT_AOE3, client);
			}

			SetEntityHealth(iNearClient, iHealth + 1);
		}
	}
}

Earthquake(client)
{
	EmitSoundToAll(SOUND_CHARGER_EARTHQUAKE, client);

	new Float:clientPos[3];
	GetClientAbsOrigin(client, clientPos);

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x))
		{
			new Float:xPos[3];
			GetClientAbsOrigin(x, xPos);

			if (IsPlayerSurvivor(x) && (GetVectorDistance(clientPos, xPos) <= 400) && InLineOfSight(client, x))
			{
				if (!IsPlayerPinned(x))
				{
					new Float:vector[3];
					vector[0] = 0.0;
					vector[1] = 0.0;
					vector[2] = 0.0;
					SDKCall(g_hCTerrorPlayerFling, x, vector, 76, client, 5);
				}

				ApplyDamage(client, x, 25);

				new flags = GetCommandFlags("shake");
				SetCommandFlags("shake", flags & ~FCVAR_CHEAT);
				FakeClientCommand(x, "shake");
				SetCommandFlags("shake", flags|FCVAR_CHEAT);
			}
		}
	}
}

Electrocute(attacker, victim)
{
	EmitSoundToAll(SOUND_SMOKER_ELECTRICITY, victim);
	ApplyDamage(attacker, victim, 10);

	new Float:victimPos[3];
	GetClientAbsOrigin(victim, victimPos);

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && x != victim)
		{
			new Float:xPos[3];
			GetClientAbsOrigin(x, xPos);

			if (IsPlayerSurvivor(x) && (GetVectorDistance(victimPos, xPos) <= 800))
			{
				ApplyDamage(attacker, x, 5);
			}
		}
	}
}

Vomit(attacker, victim)
{
	SDKCall(g_hOnVomitedUpon, victim, attacker, true);
}

ResetAbility(client, Float:time)
{
	new ability = GetEntPropEnt(client, Prop_Send, "m_customAbility");

	if (ability > 0)
	{
		SetEntPropFloat(ability, Prop_Send, "m_duration", time);
		SetEntPropFloat(ability, Prop_Send, "m_timestamp", GetGameTime() + time);
	}
}

Pipebomb(client)
{
	new Float:vAng[3], Float:vPos[3];
	GetClientAbsOrigin(client, vPos);
	vPos[2] += 20.0;

	new entity = SDKCall(g_hCreatePipe, vPos, vAng, vAng, vAng, client, 5.0);

	CreateParticle(entity, 0);
	CreateParticle(entity, 1);
}

CreateParticle(target, type)
{
	new entity = CreateEntityByName("info_particle_system");
	if( type == 0 )	DispatchKeyValue(entity, "effect_name", "weapon_pipebomb_fuse");
	else			DispatchKeyValue(entity, "effect_name", "weapon_pipebomb_blinking_light");

	DispatchSpawn(entity);
	ActivateEntity(entity);
	AcceptEntityInput(entity, "Start");

	SetVariantString("!activator");
	AcceptEntityInput(entity, "SetParent", target);

	if( type == 0 )	SetVariantString("fuse");
	else			SetVariantString("pipebomb_light");
	AcceptEntityInput(entity, "SetParentAttachment", target);
}

StartGlow(client)
{
	// To set glow color, calculate using RGB values: red + (green * 256) + (blue * 65536)
	SetEntProp(client, Prop_Send, "m_iGlowType", 3);
	if (IsPlayerGhost(client))
		SetEntProp(client, Prop_Send, "m_glowColorOverride", 16777215);
	else
		SetEntProp(client, Prop_Send, "m_glowColorOverride", 255);
	AcceptEntityInput(client, "StartGlowing");
}

StopGlow(client)
{
	if (IsPlayerSurvivor(client))
	{
		SetEntProp(client, Prop_Send, "m_bSurvivorGlowEnabled", 0);
		SetEntProp(client, Prop_Send, "m_iGlowType", 0);
		AcceptEntityInput(client, "StopGlowing");
	}

	else if (IsPlayerInfected(client))
	{
		SetEntProp(client, Prop_Send, "m_iGlowType", 0);
		AcceptEntityInput(client, "StopGlowing");
	}
}

GetClientAimPosition(client, Float:vec[3])
{
	decl Float:vAngles[3];
	decl Float:vOrigin[3];
	decl Float:vBuffer[3];
	decl Float:vStart[3];
	decl Float:Distance;

	GetClientEyePosition(client, vOrigin);
	GetClientEyeAngles(client, vAngles);

	new Handle:hTrace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);

	TR_GetEndPosition(vStart, hTrace);
	GetVectorDistance(vOrigin, vStart, false);
	Distance = -35.0;
	GetAngleVectors(vAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
	vec[0] = vStart[0] + (vBuffer[0]*Distance);
	vec[1] = vStart[1] + (vBuffer[1]*Distance);
	vec[2] = vStart[2] + (vBuffer[2]*Distance);

	CloseHandle(hTrace);
}

public bool:TraceEntityFilterPlayer(entity, contentsMask)
{
	return entity > MaxClients || !entity;
}

GetNearestClient(client)
{
	new Float:clientPos[3];
	GetClientAbsOrigin(client, clientPos);

	new Float:iDistance[MAXPLAYERS+1];
	new iNearestClient = client;

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && IsPlayerAlive(x) && !IsPlayerIncapped(x) && x != client)
		{
			new iMaxHealth = GetEntProp(x, Prop_Data, "m_iMaxHealth");
			new iHealth = GetClientHealth(x);

			if (iHealth/iMaxHealth < 1.0)
			{
				new Float:xPos[3];
				GetClientAbsOrigin(x, xPos);

				iDistance[x] = GetVectorDistance(clientPos, xPos);
			}
		}
	}

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerSurvivor(x) && (iDistance[x] < iDistance[iNearestClient] || iNearestClient == client) && x != client)
		{
			new iMaxHealth = GetEntProp(x, Prop_Data, "m_iMaxHealth");
			new iHealth = GetClientHealth(x);

			if (iHealth/iMaxHealth < 1.0)
			{
				iNearestClient = x;
			}
		}
	}

	return iNearestClient;
}

StaggerPlayer(target, client)
{
	new Float:vecOrigin[3];
	GetClientAbsOrigin(client, vecOrigin);
	SDKCall(g_hOnStaggered, target, client, vecOrigin);
}

GetInfectedAttacker(client)
{
    new attacker;

    /* Charger */
    attacker = GetEntPropEnt(client, Prop_Send, "m_pummelAttacker");
    if (attacker > 0)
    {
        return attacker;
    }

    attacker = GetEntPropEnt(client, Prop_Send, "m_carryAttacker");
    if (attacker > 0)
    {
        return attacker;
    }

    /* Hunter */
    attacker = GetEntPropEnt(client, Prop_Send, "m_pounceAttacker");
    if (attacker > 0)
    {
        return attacker;
    }

    /* Smoker */
    attacker = GetEntPropEnt(client, Prop_Send, "m_tongueOwner");
    if (attacker > 0)
    {
        return attacker;
    }

    /* Jockey */
    attacker = GetEntPropEnt(client, Prop_Send, "m_jockeyAttacker");
    if (attacker > 0)
    {
        return attacker;
    }

    return -1;
}

GetSurvivorVictim(client)
{
    new victim;

    /* Charger */
    victim = GetEntPropEnt(client, Prop_Send, "m_pummelVictim");
    if (victim > 0)
    {
        return victim;
    }

    victim = GetEntPropEnt(client, Prop_Send, "m_carryVictim");
    if (victim > 0)
    {
        return victim;
    }

    /* Hunter */
    victim = GetEntPropEnt(client, Prop_Send, "m_pounceVictim");
    if (victim > 0)
    {
        return victim;
    }

    /* Smoker */
    victim = GetEntPropEnt(client, Prop_Send, "m_tongueVictim");
    if (victim > 0)
    {
        return victim;
    }

    /* Jockey */
    victim = GetEntPropEnt(client, Prop_Send, "m_jockeyVictim");
    if (victim > 0)
    {
        return victim;
    }

    return -1;
}

JockeyJump(client)
{
	EmitSoundToAll(SOUND_JOCKEY_JUMP, client);

	new Float:velo[3];
	velo[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
	velo[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
	velo[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");

	if (velo[2] != 0) return;

	new Float:vec[3];
	vec[0] = velo[0];
	vec[1] = velo[1];
	vec[2] = velo[2] + 330.0;

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vec);
}


TankRoar(client)
{
	EmitSoundToAll(SOUND_TANK_ROAR, client);

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsValidEntity(x) && IsPlayerSurvivor(x) && !IsPlayerPinned(x))
		{
			new Float:clientPos[3];
			new Float:xPos[3];
			GetClientEyePosition(client, clientPos);
			GetClientEyePosition(x, xPos);

			if (GetVectorDistance(clientPos, xPos) <= 600 && InLineOfSight(client, x))
			{
				decl String:sRadius[256];
				decl String:sPower[256];
				new RoarType = 1;
				new magnitude;
				if (RoarType == 1) magnitude = 300;
				if (RoarType == 2) magnitude = 300 * -1;
				IntToString(700, sRadius, sizeof(sRadius));
				IntToString(magnitude, sPower, sizeof(sPower));
				new exPhys = CreateEntityByName("env_physexplosion");

				//Set up physics movement explosion
				DispatchKeyValue(exPhys, "radius", sRadius);
				DispatchKeyValue(exPhys, "magnitude", sPower);
				DispatchSpawn(exPhys);
				TeleportEntity(exPhys, clientPos, NULL_VECTOR, NULL_VECTOR);

				//BOOM!
				AcceptEntityInput(exPhys, "Explode");

				decl Float:traceVec[3], Float:resultingVec[3], Float:currentVelVec[3];
				new Float:power = 300.0;
				MakeVectorFromPoints(clientPos, xPos, traceVec);				// draw a line from car to Survivor
				GetVectorAngles(traceVec, resultingVec);							// get the angles of that line

				resultingVec[0] = Cosine(DegToRad(resultingVec[1])) * power;	// use trigonometric magic
				resultingVec[1] = Sine(DegToRad(resultingVec[1])) * power;
				resultingVec[2] = power * 1.5;

				GetEntPropVector(x, Prop_Data, "m_vecVelocity", currentVelVec);		// add whatever the Survivor had before
				resultingVec[0] += currentVelVec[0];
				resultingVec[1] += currentVelVec[1];
				resultingVec[2] += currentVelVec[2];

				SDKCall(g_hCTerrorPlayerFling, x, resultingVec, 76, client, 5);
				ApplyDamage(client, x, 10);
			}
		}
	}
}

bool:InLineOfSight(Viewer, Target/*, Float:fMaxDistance=0.0, Float:fThreshold=0.73*/)
{
	decl Float:fViewPos[3];   GetClientEyePosition(Viewer, fViewPos);
	decl Float:fViewAng[3];   GetClientEyeAngles(Viewer, fViewAng);
	decl Float:fViewDir[3];
	decl Float:fTargetPos[3]; GetClientEyePosition(Target, fTargetPos);

	fViewAng[0] = fViewAng[2] = 0.0;
	GetAngleVectors(fViewAng, fViewDir, NULL_VECTOR, NULL_VECTOR);

	new Handle:hTrace = TR_TraceRayFilterEx(fViewPos, fTargetPos, MASK_PLAYERSOLID_BRUSHONLY, RayType_EndPoint, InLineOfSightFilter);
	if (TR_DidHit(hTrace)) { CloseHandle(hTrace); return false; }
	CloseHandle(hTrace);

	return true;
}

public bool:InLineOfSightFilter(Entity, Mask, any:Junk)
{
	if (Entity >= 1 && Entity <= MaxClients) return false;
	return true;
}

bool:IsPlayerSpectator(client)
{
	if (GetClientTeam(client) == 1)
		return true;
	else
		return false;
}

bool:IsPlayerSurvivor(client)
{
	if (GetClientTeam(client) == 2)
		return true;
	else
		return false;
}

bool:IsPlayerInfected(client)
{
	if (GetClientTeam(client) == 3)
		return true;
	else
		return false;
}

bool:IsPlayerGhost(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isGhost");
}

bool:IsPlayerIncapped(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isIncapacitated");
}

bool:IsPlayerGrounded(client)
{
	return (GetEntProp(client, Prop_Data, "m_fFlags") & FL_ONGROUND) > 0;
}

bool:IsPlayerPouncing(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isAttemptingToPounce");
}

bool:IsPlayerSmoker(client)
{
	if (GetEntProp(client, Prop_Send, "m_zombieClass") == 1)
		return true;
	else
		return false;
}

bool:IsPlayerBoomer(client)
{
	if (GetEntProp(client, Prop_Send, "m_zombieClass") == 2)
		return true;
	else
		return false;
}

bool:IsPlayerHunter(client)
{
	if (GetEntProp(client, Prop_Send, "m_zombieClass") == 3)
		return true;
	else
		return false;
}

bool:IsPlayerSpitter(client)
{
	if (GetEntProp(client, Prop_Send, "m_zombieClass") == 4)
		return true;
	else
		return false;
}

bool:IsPlayerJockey(client)
{
	if (GetEntProp(client, Prop_Send, "m_zombieClass") == 5)
		return true;
	else
		return false;
}

bool:IsPlayerCharger(client)
{
	if (GetEntProp(client, Prop_Send, "m_zombieClass") == 6)
		return true;
	else
		return false;
}

bool:IsPlayerTank(client)
{
	if (GetEntProp(client, Prop_Send, "m_zombieClass") == 8)
		return true;
	else
		return false;
}

bool:IsClassBoomer(client)
{
	if (StrEqual(g_sInfClassOne[client], "Boomer") || StrEqual(g_sInfClassTwo[client], "Boomer") || StrEqual(g_sInfClassThree[client], "Boomer"))
		return true;
	else
		return false;
}

bool:IsClassCharger(client)
{
	if (StrEqual(g_sInfClassOne[client], "Charger") || StrEqual(g_sInfClassTwo[client], "Charger") || StrEqual(g_sInfClassThree[client], "Charger"))
		return true;
	else
		return false;
}

bool:IsClassHunter(client)
{
	if (StrEqual(g_sInfClassOne[client], "Hunter") || StrEqual(g_sInfClassTwo[client], "Hunter") || StrEqual(g_sInfClassThree[client], "Hunter"))
		return true;
	else
		return false;
}

bool:IsClassJockey(client)
{
	if (StrEqual(g_sInfClassOne[client], "Jockey") || StrEqual(g_sInfClassTwo[client], "Jockey") || StrEqual(g_sInfClassThree[client], "Jockey"))
		return true;
	else
		return false;
}

bool:IsClassSmoker(client)
{
	if (StrEqual(g_sInfClassOne[client], "Smoker") || StrEqual(g_sInfClassTwo[client], "Smoker") || StrEqual(g_sInfClassThree[client], "Smoker"))
		return true;
	else
		return false;
}

bool:IsClassSpitter(client)
{
	if (StrEqual(g_sInfClassOne[client], "Spitter") || StrEqual(g_sInfClassTwo[client], "Spitter") || StrEqual(g_sInfClassThree[client], "Spitter"))
		return true;
	else
		return false;
}

bool:IsClassProtector(client)
{
	if (StrEqual(g_sSurvClass[client], "Protector"))
		return true;
	else
		return false;
}

bool:IsClassCommando(client)
{
	if (StrEqual(g_sSurvClass[client], "Commando"))
		return true;
	else
		return false;
}

bool:IsClassSupport(client)
{
	if (StrEqual(g_sSurvClass[client], "Support"))
		return true;
	else
		return false;
}

bool:IsClassMedic(client)
{
	if (StrEqual(g_sSurvClass[client], "Medic"))
		return true;
	else
		return false;
}

bool:IsClassRecon(client)
{
	if (StrEqual(g_sSurvClass[client], "Recon"))
		return true;
	else
		return false;
}

bool:IsPlayerConfirmed(client)
{
	return g_bConfirmedSetup[client];
}

bool:IsPlayerPinned(client)
{
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerInfected(x))
		{
			if (GetEntPropEnt(x, Prop_Send, "m_jockeyVictim") == client)
			{
				return true;
			}

			else if (GetEntPropEnt(x, Prop_Send, "m_tongueVictim") == client)
			{
				return true;
			}

			else if (GetEntPropEnt(x, Prop_Send, "m_pounceVictim") == client)
			{
				return true;
			}

			else if (GetEntPropEnt(x, Prop_Send, "m_carryVictim") == client)
			{
				return true;
			}

			else if (GetEntPropEnt(x, Prop_Send, "m_pummelVictim") == client)
			{
				return true;
			}
		}
	}

	return false;
}

bool:IsClientAuthor(client)
{
	new String:sAuth[24];
	GetClientAuthId(client, AuthId_SteamID64, sAuth, sizeof(sAuth));

	if (StrEqual(sAuth, "76561198039948092"))
		return true;
	else
		return false;
}

DetermineClass(client)
{
	new iClass = GetEntProp(client, Prop_Send, "m_zombieClass");

	if (iClass == 6)
	{
		g_iNextClass[client] = 1;
	}

	else
	{
		g_iNextClass[client] = iClass + 1;
	}

	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsClientInGame(x) && IsPlayerAlive(x) && IsPlayerInfected(x))
		{
			for (new y = 1; y <= 6; y++)
			{
				if (GetEntProp(x, Prop_Send, "m_zombieClass") != y && iClass != y && g_iNextClass[client] == y)
				{
					new WeaponIndex = GetPlayerWeaponSlot(client, 0);
					RemovePlayerItem(client, WeaponIndex);
					SDKCall(g_hSetClass, client, y);
					SetEntProp(client, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, client), g_iAbility));
					return;
				}
			}
		}
	}
}

ResetGlobals(client)
{
	g_bConfirmedSetup[client] = false;
	g_bBindOneActive[client] = false;
	g_bBindTwoActive[client] = false;
	g_bBindOneCooldown[client] = false;
	g_bBindTwoCooldown[client] = false;
	g_bBindWitchCooldown[client] = false;
	g_bJockeyJumpCooldown[client] = false;
	g_bJockeyInvisibility[client] = false;
	g_bTankRoarCooldown[client] = false;
	g_bInfectedSelectCooldown[client] = false;
	g_bStatsPanel[client] = false;
	g_iBindOneUses[client] = 3;
	g_iBindTwoUses[client] = 3;
	g_iBindOneCooldown[client] = 0;
	g_iBindTwoCooldown[client] = 0;
	g_iBindWitchCooldown[client] = 0;
	g_iJockeyJumpCooldown[client] = 0;
	g_iTankRoarCooldown[client] = 0;
	g_iPipeBombTicks[client] = 0;
	g_iHunterPoisonTicks[client] = 0;
	g_iSmokerInvisibilityTicks[client] = 0;
	g_iSmokerElectricityTicks[client] = 0;
	g_iSpitterSpitCount[client] = 0;
	g_iChargerVictim[client] = 0;
	g_iHunterVictim[client] = 0;
	g_iJockeyVictim[client] = 0;
	g_iSmokerVictim[client] = 0;
	g_iNextClass[client] = 0;

	g_bChargerUppercutCooldown[client] = false;
	g_bChargerUppercutActive[client] = false;
	g_bChargerUppercutCharging[client] = false;
	g_iChargerUppercutCooldown[client] = 0;
	g_iChargerUppercutCharged[client] = 0;

	g_bReconJumpCooldown[client] = false;
	g_bReconJumpActive[client] = false;
	g_bReconJumpCharging[client] = false;
	g_iReconJumpCooldown[client] = 0;
	g_iReconJumpCharged[client] = 0;

	g_bSpitterShiftCooldown[client] = false;
	g_bSpitterShiftActive[client] = false;
	g_bSpitterShiftCharging[client] = false;
	g_iSpitterShiftCooldown[client] = 0;
	g_iSpitterShiftCharged[client] = 0;

	g_bHunterPounceCooldown[client] = false;
	g_bHunterPounceActive[client] = false;
	g_bHunterPounceCharging[client] = false;
	g_iHunterPounceCooldown[client] = 0;
	g_iHunterPounceCharged[client] = 0;

	g_bHunterInvisibilityActive[client] = false;
	g_iHunterInvisiblityTicks[client] = 0;
	g_iHunterVisiblityTicks[client] = 0;
}

KillTimers(client)
{
	if (g_hBindOneCooldown[client] != INVALID_HANDLE) { KillTimer(g_hBindOneCooldown[client]); g_hBindOneCooldown[client] = INVALID_HANDLE; }
	if (g_hBindTwoCooldown[client] != INVALID_HANDLE) { KillTimer(g_hBindTwoCooldown[client]); g_hBindTwoCooldown[client] = INVALID_HANDLE; }
	if (g_hBindWitchCooldown[client] != INVALID_HANDLE) { KillTimer(g_hBindWitchCooldown[client]); g_hBindWitchCooldown[client] = INVALID_HANDLE; }
	if (g_hJockeyJumpCooldown[client] != INVALID_HANDLE) { KillTimer(g_hJockeyJumpCooldown[client]); g_hJockeyJumpCooldown[client] = INVALID_HANDLE; }
	if (g_hTankRoarCooldown[client] != INVALID_HANDLE) { KillTimer(g_hTankRoarCooldown[client]); g_hTankRoarCooldown[client] = INVALID_HANDLE; }

	if (g_hFireMode[client] != INVALID_HANDLE) { KillTimer(g_hFireMode[client]); g_hFireMode[client] = INVALID_HANDLE; }
	if (g_hPipeBomb[client] != INVALID_HANDLE) { KillTimer(g_hPipeBomb[client]); g_hPipeBomb[client] = INVALID_HANDLE; }
	if (g_hBoost[client] != INVALID_HANDLE) { KillTimer(g_hBoost[client]); g_hBoost[client] = INVALID_HANDLE; }
	if (g_hInvulnerability[client] != INVALID_HANDLE) { KillTimer(g_hInvulnerability[client]); g_hInvulnerability[client] = INVALID_HANDLE; }
	if (g_hInvisibility[client] != INVALID_HANDLE) { KillTimer(g_hInvisibility[client]); g_hInvisibility[client] = INVALID_HANDLE; }

	if (g_hBoomerHotMeal[client] != INVALID_HANDLE) { KillTimer(g_hBoomerHotMeal[client]); g_hBoomerHotMeal[client] = INVALID_HANDLE; }
	if (g_hJockeyInvisibility[client] != INVALID_HANDLE) { KillTimer(g_hJockeyInvisibility[client]); g_hJockeyInvisibility[client] = INVALID_HANDLE; }
	if (g_hSmokerInvisibility[client] != INVALID_HANDLE) { KillTimer(g_hSmokerInvisibility[client]); g_hSmokerInvisibility[client] = INVALID_HANDLE; }
	if (g_hSmokerElectricity[client] != INVALID_HANDLE) { KillTimer(g_hSmokerElectricity[client]); g_hSmokerElectricity[client] = INVALID_HANDLE; }

	if (g_hChargerUppercutCooldown[client] != INVALID_HANDLE) { KillTimer(g_hChargerUppercutCooldown[client]); g_hChargerUppercutCooldown[client] = INVALID_HANDLE; }
	if (g_hReconJumpCooldown[client] != INVALID_HANDLE) { KillTimer(g_hReconJumpCooldown[client]); g_hReconJumpCooldown[client] = INVALID_HANDLE; }
	if (g_hSpitterShiftCooldown[client] != INVALID_HANDLE) { KillTimer(g_hSpitterShiftCooldown[client]); g_hSpitterShiftCooldown[client] = INVALID_HANDLE; }
	if (g_hSpitterShiftActive[client] != INVALID_HANDLE) { KillTimer(g_hSpitterShiftActive[client]); g_hSpitterShiftActive[client] = INVALID_HANDLE; }
	if (g_hHunterPounceCooldown[client] != INVALID_HANDLE) { KillTimer(g_hHunterPounceCooldown[client]); g_hHunterPounceCooldown[client] = INVALID_HANDLE; }
	if (g_hHunterPounceActive[client] != INVALID_HANDLE) { KillTimer(g_hHunterPounceActive[client]); g_hHunterPounceActive[client] = INVALID_HANDLE; }
	if (g_hHunterInvisibilityActive[client] != INVALID_HANDLE) { KillTimer(g_hHunterInvisibilityActive[client]); g_hHunterInvisibilityActive[client] = INVALID_HANDLE; }
	if (g_hHunterVisibilityActive[client] != INVALID_HANDLE) { KillTimer(g_hHunterVisibilityActive[client]); g_hHunterVisibilityActive[client] = INVALID_HANDLE; }
}

// #define FFADE_IN			0x0001		// Just here so we don't pass 0 into the function
// #define FFADE_OUT			0x0002		// Fade out (not in)
// #define FFADE_MODULATE		0x0004		// Modulate (don't blend)
// #define FFADE_STAYOUT		0x0008		// ignores the duration, stays faded out until new ScreenFade message received
// #define FFADE_PURGE			0x0010		// Purges all other fades, replacing them with this one

Blind(client, duration)
{
	new Handle:message = StartMessageOne("Fade", client, 1);

	if (IsClientInGame(client))
	{
		BfWriteShort(message, 1); //fade time
		BfWriteShort(message, duration * 500); //duration
		BfWriteShort(message, (0x0002)); //fade mode
		BfWriteByte(message, 0); //fade red
		BfWriteByte(message, 0); //fade green
		BfWriteByte(message, 0); //fade blue
		BfWriteByte(message, 255); //fade alpha

		EndMessage();
	}
}

RemovePrimaryWeapon(client)
{
	new primary = GetPlayerWeaponSlot(client, 0);

	if (IsValidEdict(primary))
	{
		RemoveEdict(primary);
	}
}

RemoveSecondaryWeapon(client)
{
	new secondary = GetPlayerWeaponSlot(client, 1);

	if (IsValidEdict(secondary))
	{
		RemoveEdict(secondary);
	}
}

Uppercut(attacker, victim)
{
	if (IsClientInGame(victim))
	{
		decl Float:HeadingVector[3], Float:AimVector[3];
		new Float:power = 275.0;

		GetClientEyeAngles(attacker, HeadingVector);

		AimVector[0] = FloatMul( Cosine( DegToRad(HeadingVector[1])  ) , power);
		AimVector[1] = FloatMul( Sine( DegToRad(HeadingVector[1])  ) , power);

		decl Float:current[3];
		GetEntPropVector(victim, Prop_Data, "m_vecVelocity", current);

		decl Float:resulting[3];
		resulting[0] = FloatAdd(current[0], AimVector[0]);
		resulting[1] = FloatAdd(current[1], AimVector[1]);
		resulting[2] = power * 1.5;

		SDKCall(g_hCTerrorPlayerFling, victim, resulting, 76, attacker, 5);
	}
}

bool:IsMissingSetup(client)
{
	if (StrEqual(g_sSurvClass[client], "") || StrEqual(g_sPrimary[client], "") || StrEqual(g_sSecondary[client], "") || StrEqual(g_sGrenade[client], "") || StrEqual(g_sHealth[client], "") || StrEqual(g_sBoost[client], "") || StrEqual(g_sInfClassOne[client], "") || StrEqual(g_sInfClassTwo[client], "") || StrEqual(g_sInfClassThree[client], ""))
	{
		return true;
	}

	else
	{
		return false;
	}
}