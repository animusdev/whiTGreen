///// Z-Level stuff
/obj/structure/disposalpipe/crossZ/up
   icon_state = "pipe-u"
   layer = 2.8
   density = 1

   New()
      ..()
      dpdir = dir
      update()
      return

   nextdir(var/fromdir)
      var/nextdir
      if(fromdir == 32)
         nextdir = dir
      else
         nextdir = 16
      return nextdir

   transfer(var/obj/structure/disposalholder/H)
      var/nextdir = nextdir(H.dir)
      H.dir = nextdir

      var/turf/T
      var/obj/structure/disposalpipe/P

      if(nextdir == 16)
         T = GetAbove(H)
         if(!T)
            H.loc = src.loc
            return
         else
            for(var/obj/structure/disposalpipe/crossZ/down/F in T)
               P = F

      else
         T = get_step(src.loc, H.dir)
         P = H.findpipe(T)

      if(P)
         // find other holder in next loc, if inactive merge it with current
         var/obj/structure/disposalholder/H2 = locate() in P
         if(H2 && !H2.active)
            H.merge(H2)

         H.loc = P
      else         // if wasn't a pipe, then set loc to turf
         H.loc = T
         return null

      return P

/obj/structure/disposalpipe/crossZ/up/hide()   //nope
   invisibility =  0
   update_icon()

/obj/structure/disposalpipe/crossZ/down
   icon_state = "pipe-d"

   New()
      ..()
      dpdir = dir
      update()
      return

   nextdir(var/fromdir)
      var/nextdir
      if(fromdir == 16)
         nextdir = dir
      else
         nextdir = 32
      return nextdir

   transfer(var/obj/structure/disposalholder/H)
      var/nextdir = nextdir(H.dir)
      H.dir = nextdir

      var/turf/T
      var/obj/structure/disposalpipe/P

      if(nextdir == 32)
         T = GetBelow(H)
         if(!T)
            H.loc = src.loc
            return
         else
            for(var/obj/structure/disposalpipe/crossZ/up/F in T)
               P = F

      else
         T = get_step(src.loc, H.dir)
         P = H.findpipe(T)

      if(P)
         // find other holder in next loc, if inactive merge it with current
         var/obj/structure/disposalholder/H2 = locate() in P
         if(H2 && !H2.active)
            H.merge(H2)

         H.loc = P
      else         // if wasn't a pipe, then set loc to turf
         H.loc = T
         return null

      return P
///// Z-Level stuff