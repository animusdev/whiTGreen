mob/living/carbon/proc/dream()
	dreaming = 1
	var/list/dreams = list(
		"гнев", "одиночество", "катастрофа", "любимая", "пустота", "сингулярность", "кровь",
		"тьма", "голоса в моей голове", "ненависть", "мёртвый друг", "предательство", "глубокий космос", "проститутка",
		"неудача", "заброшенная лаборатория", "кошмар", "гордость", "ледяное безмолвие", "атмосфера", "казнь",
		"плазма", "безысходность", "уныние", "пламя", "мёртвое солнце", "самоубийство", "забвение", "недоверие",
		"разрушенная станция", "самоуничтожение", "порок", "жажда крови", "вечная борьба", "сто лет одиночества"
		)
	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			var/dream_image = pick(dreams)
			dreams -= dream_image
			src << "<span class='notice'><i>... [dream_image] ...</i></span>"
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		dreaming = 0
		return 1

mob/living/carbon/proc/handle_dreams()
	if(prob(5) && !dreaming) dream()

mob/living/carbon/var/dreaming = 0