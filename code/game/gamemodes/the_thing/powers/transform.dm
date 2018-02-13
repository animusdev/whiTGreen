/obj/effect/proc_holder/the_thing/transform
	name = "Transform"
	desc = "We take on the appearance and voice of one we have absorbed."
	req_human = 1


//Change our DNA to that of somebody we've absorbed.
/obj/effect/proc_holder/the_thing/transform/ability_action(var/mob/living/carbon/human/user)
	var/datum/the_thing/thing = user.mind.the_thing
	var/datum/dna/chosen_dna = thing.select_dna("Select the target DNA: ", "Target DNA")

	if(!chosen_dna)
		return

	user.dna = chosen_dna
	user.real_name = chosen_dna.real_name
	hardset_dna(user, null, null, null, null, chosen_dna.species.type)
	user.dna.mutant_color = chosen_dna.mutant_color
	updateappearance(user)
	domutcheck(user)
	return 1

/datum/the_thing/proc/select_dna(var/prompt, var/title)
	var/list/names = list()
	for(var/datum/dna/DNA in (absorbed_dna+protected_dna))
		names += "[DNA.real_name]"

	var/chosen_name = input(prompt, title, null) as null|anything in names
	if(!chosen_name)
		return
	var/datum/dna/chosen_dna = get_dna(chosen_name)
	return chosen_dna