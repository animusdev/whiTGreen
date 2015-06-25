/mob/living/silicon/robot/IsVocal()
	return !config.silent_borg

/mob/living/silicon/robot/get_message_mode(message)
	var/message_mode=..()
	if(message_mode==MODE_DEPARTMENT)
		if(length(radio.channels)>0)
			message_mode=radio.channels[1]
	return message_mode
