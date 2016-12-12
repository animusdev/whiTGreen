/datum/round_event_control/meme
    name = "Memetic Anomaly"
    typepath = /datum/round_event/meme
    weight = 15
    max_occurrences = 3
    minimal_players = 10

/datum/round_event/meme

    var/spawncount = 1
    var/successSpawn = 0    //So we don't make a command report if nothing gets spawned.

/datum/round_event/meme/setup()
    spawncount = rand(1, 2)

/datum/round_event/meme/kill()
    if(!successSpawn && control)
        control.occurrences--
    return ..()

/datum/round_event/meme/start()
    var/list/candidates = get_candidates(BE_MEME, MEME_AFK_BRACKET) // meme is alien FTW
    var/list/host_candidates = list()
    var/list/living_crew = list() //actually it's living ACTIVE crew. We don't want our meme to be stuck in apatic bum somewhere in maintenance
    for(var/mob/Player in mob_list)
        if(Player.mind && Player.stat != DEAD && !isnewplayer(Player) &&!isbrain(Player)&&(Player in player_list))
            living_crew += Player
    for(var/mob/living/carbon/human/H in living_crew)
        if(H.client)
            host_candidates += H
    if(!candidates.len)
        message_admins("No candidates for [src] found")
        return
    if(!host_candidates.len)
        message_admins("No hosts for [src] found")
        return
    while(spawncount > 0 && candidates.len)
        var/mob/living/carbon/human/host = pick(host_candidates)
        var/client/C = pop(candidates)
        if(!C) return
        if(C.special_role_accept("meme"))
            var/mob/living/parasite/meme/new_meme = new(host)
            new_meme.key = C.key
            spawncount--
            successSpawn = 1