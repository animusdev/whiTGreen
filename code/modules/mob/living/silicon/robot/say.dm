/mob/living/silicon/robot/IsVocal()
	return !config.silent_borg

/mob/living/silicon/robot/get_message_mode(message)
	var/message_mode=..()
	world<<message_mode
	world<<radio.channels[1]
	if(message_mode==MODE_DEPARTMENT)
		message_mode=radio.channels[1]
	return message_mode
