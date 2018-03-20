//print an error message to world.log
#define ERROR(MSG) error("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
/proc/error(msg)
	world.log << "## ERROR: [msg]"

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
/proc/warning(msg)
	world.log << "## WARNING: [msg]"

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	world.log << "## NOTICE: [msg]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
#ifdef TESTING
	world.log << "## TESTING: [msg]"
#endif

/proc/message_admins(var/msg)
	webhook_send_garbage("ADMIN LOG", msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	admins << msg

/proc/log_admin(text)
	admin_log.Add(text)
	diary << "\[[time_stamp()]]ADMIN: [text]"

/proc/log_game(text)
	diary << "\[[time_stamp()]]GAME: [text]"

/proc/log_vote(text)
	diary << "\[[time_stamp()]]VOTE: [text]"

/proc/log_access(text)
	diary << "\[[time_stamp()]]ACCESS: [text]"

/proc/log_say(text)
	diary << "\[[time_stamp()]]SAY: [text]"

/proc/log_prayer(text)
	diary << "\[[time_stamp()]]PRAY: [text]"

/proc/log_law(text)
	diary << "\[[time_stamp()]]LAW: [text]"

/proc/log_ooc(text)
	diary << "\[[time_stamp()]]OOC: [text]"

/proc/log_whisper(text)
	diary << "\[[time_stamp()]]WHISPER: [text]"

/proc/log_emote(text)
	diary << "\[[time_stamp()]]EMOTE: [text]"

/proc/log_attack(text)
	diary << "\[[time_stamp()]]ATTACK: [text]"

/proc/log_adminsay(text)
	diary << "\[[time_stamp()]]ADMINSAY: [text]"

/proc/log_pda(text)
	diary << "\[[time_stamp()]]PDA: [text]"

/proc/log_chat(text)
	diary << "\[[time_stamp()]]CHAT: [text]"

/proc/log_comment(text)
	diary << "\[[time_stamp()]]COMMENT: [text]"

/proc/log_runtime(text)
	diary << "\[[time2text(world.timeofday,"hh:mm:ss")]]RUNTIME: [text]" //time2text instead of time_stamp because of strange magic that can happen
	webhook_send_runtime(text)

/proc/datum_info_line(datum/D)
	if(!istype(D))
		return
	if(!ismob(D))
		return "[D] ([D.type])"
	var/mob/M = D
	return "[M] ([M.ckey]) ([M.type])"

#define COORD(src) "[src ? "([src.x],[src.y],[src.z])" : "nonexistent location"]"
/proc/atom_loc_line(atom/A)
	if(!istype(A))
		return
	var/turf/T = get_turf(A)
	if(istype(T))
		return "[A.loc] [COORD(T)] ([A.loc.type])"
	else if(A.loc)
		return "[A.loc] (0, 0, 0) ([A.loc.type])"