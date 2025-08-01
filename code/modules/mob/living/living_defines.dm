

/mob/living
	see_invisible = SEE_INVISIBLE_LIVING
	sight = 0
	see_in_dark = 8
	hud_possible = list(ANTAG_HUD)
	
	typing_indicator_enabled = TRUE
	
	var/resize = 1 //Badminnery resize
	var/lastattacker = null
	var/lastattackerckey = null

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0	//Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0		//Oxygen depravation damage (no air in lungs)
	var/toxloss = 0		//Toxic damage caused by being poisoned or radiated
	var/fireloss = 0	//Burn damage caused by being way too hot, too cold or burnt.
	var/cloneloss = 0	//Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
	var/staminaloss = 0		//Stamina damage, or exhaustion. You recover it slowly naturally, and are knocked down if it gets too high. Holodeck and hallucinations deal this.
	var/crit_threshold = HEALTH_THRESHOLD_CRIT // when the mob goes from "normal" to crit

	var/mobility_flags = MOBILITY_FLAGS_DEFAULT

	var/resting = FALSE
	var/wallpressed = FALSE

	var/pixelshift_layer = 0

	var/lying = 0			//number of degrees. DO NOT USE THIS IN CHECKS. CHECK FOR MOBILITY FLAGS INSTEAD!!
	var/lying_prev = 0		//last value of lying on update_mobility

	var/confused = 0	//Makes the mob move in random directions.

	var/hallucination = 0 //Directly affects how long a mob will hallucinate for

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	var/timeofdeath = 0

	var/infected = FALSE //Used to tell if the mob is in progress of turning into deadite

	//Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	var/incorporeal_move = FALSE //FALSE is off, INCORPOREAL_MOVE_BASIC is normal, INCORPOREAL_MOVE_SHADOW is for ninjas
								 //and INCORPOREAL_MOVE_JAUNT is blocked by holy water/salt

	var/list/roundstart_quirks

	var/list/surgeries //a list of surgery steps. generally empty, they're added when the player is performing them.

	var/now_pushing = null //used by living/Bump() and living/PushAM() to prevent potential infinite loop.

	var/cameraFollow = null

	var/tod = null // Time of death

	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks = 0 //Tracks how many stacks of fire we have on, max is usually 20
	var/divine_fire_stacks = 0	//Same as regular firestacks but has less properties to avoid firespreading and other mechanics. Meant to ONLY harm the target.

	var/bloodcrawl = 0 //0 No blood crawling, BLOODCRAWL for bloodcrawling, BLOODCRAWL_EAT for crawling+mob devour
	var/holder = null //The holder for blood crawling
	var/ventcrawler = 0 //0 No vent crawling, 1 vent crawling in the nude, 2 vent crawling always
	var/limb_destroyer = 0 //1 Sets AI behavior that allows mobs to target and dismember limbs with their basic attack.

	var/mob_size = MOB_SIZE_HUMAN
	var/mob_biotypes = MOB_ORGANIC
	var/metabolism_efficiency = 1 //more or less efficiency to metabolize helpful/harmful reagents and regulate body temperature..
	var/has_limbs = 0 //does the mob have distinct limbs?(arms,legs, chest,head)

	var/list/pipes_shown = list()
	var/last_played_vent

	var/smoke_delay = 0 //used to prevent spam with smoke reagent reaction on mob.

	var/bubble_icon = "default" //what icon the mob uses for speechbubbles

	var/last_bumped = 0
	var/unique_name = 0 //if a mob's name should be appended with an id when created e.g. Mob (666)

	var/list/butcher_results = null //these will be yielded from butchering with a probability chance equal to the butcher item's effectiveness
	var/list/guaranteed_butcher_results = null //these will always be yielded from butchering
	var/butcher_difficulty = 0 //effectiveness prob. is modified negatively by this amount; positive numbers make it more difficult, negative ones make it easier

	var/is_jumping = 0 //to differentiate between jumping and thrown mobs

	var/hellbound = 0 //People who've signed infernal contracts are unrevivable.

	var/list/weather_immunities = list()

	var/stun_absorption = null //converted to a list of stun absorption sources this mob has when one is added

	var/blood_volume = BLOOD_VOLUME_NORMAL //how much blood the mob has

	var/see_override = 0 //0 for no override, sets see_invisible = see_override in silicon & carbon life process via update_sight()

	var/list/status_effects //a list of all status effects the mob has
	var/druggy = 0

	//Speech
	var/stuttering = 0
	var/slurring = 0
	var/cultslurring = 0
	var/derpspeech = 0

	var/list/implants = null

	var/datum/riding/riding_datum

	var/datum/language/selected_default_language

	var/last_words	//used for database logging

	var/list/obj/effect/proc_holder/abilities = list()

	var/can_be_held = FALSE	//whether this can be picked up and held.

	var/ventcrawl_layer = PIPING_LAYER_DEFAULT
	var/losebreath = 0

	var/slowed_by_drag = TRUE //Whether the mob is slowed down when dragging another prone mob

	var/list/ownedSoullinks //soullinks we are the owner of
	var/list/sharedSoullinks //soullinks we are a/the sharer of

	var/max_energy = 1000
	var/max_stamina = 100
	var/energy = 1000
	var/stamina = 0 // Stamina. In reality this is stamina damage and the higher it is the worse it is.

	var/last_fatigued = 0
	var/last_ps = 0

	var/ambushable = 0

	var/surrendering = 0
	var/compliance = 0 // whether we are choosing to auto-resist grabs and stuff

	var/defprob = 50 //base chance to defend against this mob's attacks, for simple mob combat
	var/encumbrance = 0

	var/eyesclosed = 0
	var/fallingas = 0

	var/bleed_rate = 0 //how much are we bleeding
	var/bleedsuppress = 0 //for stopping bloodloss, eventually this will be limb-based like bleeding

	var/list/next_attack_msg = list()

	///The NAME (not the reference) of the mob's summoner and probable master.
	var/summoner = null


	var/datum/component/personal_crafting/craftingthing

	var/obj/item/grabbing/r_grab = null
	var/obj/item/grabbing/l_grab = null

	var/datum/sex_controller/sexcon

	var/slowdown

	var/last_dir_change = 0

	var/list/death_trackers = list()

	var/rot_type = /datum/component/rot/simple

	var/list/mob_descriptors
	var/list/custom_descriptors

	/**This variable updated in mob_movement.dm primarily. Mainly a shitcode measure for existing shitcode because this is SHITCODE!
	 * All it does is track when a mob is sneaking so we don't have to constantly reset alpha values as this fucks with how things are intended to be.
	 * if you really need to cancel someone who is sneaking, call update_sneak_invis(TRUE).*/
	var/rogue_sneaking = FALSE
	/* Can be used to change the lighting threshholds at which players can sneak.*/
	var/rogue_sneaking_light_threshhold = 0.15

	var/voice_pitch = 1

	var/domhand = 0
