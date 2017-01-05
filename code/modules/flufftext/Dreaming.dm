mob/living/carbon/proc/dream()
   dreaming = 1
   var/list/dreams = list(
      " нев", "одиноче«ƒво", "каƒа«ƒрофа", "любима&#255;", "Ѕу«ƒоƒа", "«ин ул&#255;рно«ƒь", "кровь",
      "ƒьма", " оло«а в моей  олове", "ненави«ƒь", "мЄрƒвый дру ", "Ѕредаƒель«ƒво", " лубокий ко«мо«", "Ѕро«ƒиƒуƒка",
      "неудача", "забро∆енна&#255; лабораƒори&#255;", "ко∆мар", " ордо«ƒь", "лед&#255;ное безмолвие", "аƒмо«фера", "казнь",
      "Ѕлазма", "безы« одно«ƒь", "уныние", "Ѕлам&#255;", "мЄрƒвое «олнце", "«амоубий«ƒво", "забвение", "недоверие",
      "разру∆енна&#255; «ƒанци&#255;", "«амоуничƒожение", "Ѕорок", "жажда крови", "вечна&#255; борьба", "«ƒо леƒ одиноче«ƒва"
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