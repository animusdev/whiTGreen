/datum/round_event_control/communications_blackout
   name = "Communications Blackout"
   typepath = /datum/round_event/communications_blackout
   weight = 20

/datum/round_event/communications_blackout
   announceWhen   = 1

/datum/round_event/communications_blackout/announce()
   var/alert = pick(   "ќбнаружена ионо«фериче«ка&#255; аномали&#255;. Ќеизбежен временный оƒказ «и«ƒем ƒелекоммуникации. Ѕожалуй«ƒа, «в&#255;жи*%fj00)`5vc-BZZT", \
                  "ќбнаружена ионо«фериче«ка&#255; аномали&#255;. Ќеизбежен временный оƒказ «и«ƒем ƒелеко*3mga;b4;'1vђ-BZZZT", \
                  "ќбнаружена ионо«фериче«ка&#255; аномали&#255;. Ќеизбежен временный оƒказ «и«#MCi46:5.;@63-BZZZZT", \
                  "ќбнаружена ионо«фериче«ка&#255; анома'fZ\\kg5_0-BZZZZZT", \
                  "#4nd%;f4y6,>£%-BZZZZZZZT")

   for(var/mob/living/silicon/ai/A in player_list)   //AIs are always aware of communication blackouts.
      A << "<br>"
      A << "<span class='warning'><b>[alert]</b></span>"
      A << "<br>"

   if(prob(30))   //most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
      priority_announce(alert)


/datum/round_event/communications_blackout/start()
   for(var/obj/machinery/telecomms/T in telecomms_list)
      T.emp_act(1)