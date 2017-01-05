var/global/list/vm_names = list("MetaStation", "Secret", "Random")
var/global/list/votable_maps = list("MetaStation" = /datum/votablemap/meta,
                           "Secret" = /datum/votablemap/mapset/secret,
                           "Random" = /datum/votablemap/mapset/random)
var/global/default_map_name = ""
var/global/default_map = /datum/votablemap/meta

/datum/votablemap
   var/name = "generic map"
   var/required_players = 0

/datum/votablemap/proc/get_id()
   return null

// Some mapset
/datum/votablemap/mapset
   name = "generic mapset"
   required_players = 0
   var/maps_in_rotation = list()

/datum/votablemap/mapset/get_id()
   var/chosen_map = pick(maps_in_rotation)
   var/datum/votablemap/M = new chosen_map
   var/id = M.get_id()
   qdel(M)
   return id

// MetaStation
/datum/votablemap/meta
   name = "MetaStation"

/datum/votablemap/meta/get_id()
   return "metastation"

// Secret rotation
/datum/votablemap/mapset/secret
   name = "Secret"
   required_players = 10
   maps_in_rotation = list(/datum/votablemap/meta)

// Random rotation
/datum/votablemap/mapset/random
   name = "Random"
   required_players = 20
   maps_in_rotation = list(/datum/votablemap/meta)
