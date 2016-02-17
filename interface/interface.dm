//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if(config.wikiurl)
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		src << "<span class='danger'>The wiki URL is not set in the server configuration.</span>"
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if(config.forumurl)
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		src << "<span class='danger'>The forum URL is not set in the server configuration.</span>"
	return

/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1
	if(config.rulesurl)
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
	else
		src << "<span class='danger'>The rules URL is not set in the server configuration.</span>"
	return

/client/verb/github()
	set name = "Github"
	set desc = "Visit Github"
	set hidden = 1
	if(config.githuburl)
		if(alert("This will open the Github repository in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.githuburl)
	else
		src << "<span class='danger'>The Github URL is not set in the server configuration.</span>"
	return

/client/verb/reportissue()
	set name = "Report issue"
	set desc = "Report an issue"
	set hidden = 1
	if(config.githuburl)
		if(alert("This will open the Github issue reporter in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link("[config.githuburl]/issues/new")
	else
		src << "<span class='danger'>The Github URL is not set in the server configuration.</span>"
	return

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/adminhotkeys = {"<font color='purple'>
Admin:
F5 = Asay
F6 = Player panel
F7 = Admin PM
F8 = Aghost</font>"}

	mob.hotkey_help()

	if(holder)
		src << adminhotkeys

/mob/proc/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
Hotkey mode on: (TAB to toggle hotkey mode on and off)
W, A, S, D = movement
Ctrl+movement = face to direction
Q = Drop
E = Equip
R = Throw
B = Rest
N = Resist
T = Say
Y = Emote
O = OOC
X = Swap hands
Z = Activate held object
G = Cycle intents clockwise
F = Unholster weapon
1-4 = help, disarm, grab, harm intents
Alt+Click on other mob = give
Alt+Click on rotateable object = rotate counter-clockwise
Alt+Click on gas pump = turn on/off
Ctrl+Click on gas pump = set output pressure to max
Ctrl+Alt+Click on an object = point at
Ctrl+Click on an object = pull
Ctrl+Click on table = flip
Shift+Click on an object = examine</font>"}

	var/other = {"<font color='purple'>
Hotkey mode off:
Ctrl+whatever hotkey described above works too
DEL = Stop pulling
INSERT, Keypad-0 = Cycle intents clockwise
HOME, Keypad-7 = Drop
Page Up, Keypad-9 = Swap hands
Page Down, Keypad-3 = Activate held object
END, Keypad-1 = Throw

F1 = Adminhelp
F2 = OOC
F3 = Say
F4 = Emote</font>"}

	src << hotkey_mode
	src << other

/mob/living/silicon/robot/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
Cyborg Hotkey mode on: (TAB to toggle hotkey mode on and off)
W, A, S, D = movement
Q = Unequip active module
T = Say
Y = Emote
G = Toggle intents
Z = Activate held object
1-3 = Select modules</font>"}

	var/other = {"<font color='purple'>
Hotkey mode off:
Ctrl+WASD or arrows = movement
Ctrl+Q = unequip active module
Ctrl+G = cycle active modules
Ctrl+Z = activate held object
Ctrl+1-3 = select modules
INSERT = toggle intents
Page Up = cycle active modules
Page Down = activate held object

F1 = Adminhelp
F2 = OOC
F3 = Say
F4 = Emote</font>"}

	src << hotkey_mode
	src << other