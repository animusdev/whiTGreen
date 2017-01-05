/datum/forgotten_beast_mat // ћаƒериалы дл€ конечно«ƒей забыƒы  ƒварей «о в«еми Ѕарамеƒрами.
   var/name = "genericium"

   var/melee_resist = 0    // Ѕолучаемый урон вы«чиƒываеƒ«€ как DAMAGE * (1 - RESIST / 100),
   var/bullet_resist = 0   // ƒо е«ƒь RESIST оЅредел€еƒ количе«ƒво урона в Ѕроценƒа ,
   var/laser_resist = 0   // коƒорый будеƒ оƒражен.
   var/energy_resist = 0
   var/bomb_resist = 0
   var/rad_resist = 100   // ≈бени из чи«ƒо о золоƒа не «ƒра∆на радиаци€, верно?

   var/to_drop = list(/obj/item/weapon/ore, 1)   // –уда, коƒора€ выЅадаеƒ Ѕо«ле разру∆ени€ конечно«ƒи.

   var/limb_color = rgb(150, 150, 150)

/datum/forgotten_beast_mat/sand
   name = "sand"

   melee_resist = 15   // Ѕе«ок ле ко разру∆аеƒ«€ ударами,
   bullet_resist = 5   // но лазер Ѕлавиƒ е о и нано«иƒ
   laser_resist = 20   // мень∆е урона.
   energy_resist = 20

   to_drop = list(/obj/item/weapon/ore/glass, 8)

/datum/forgotten_beast_mat/metal
   name = "metal"

   melee_resist = 50   // «редне«ƒаƒиче«кий маƒериал.
   bullet_resist = 30   // Ќе очень  оро∆, но защищаеƒ
   laser_resist = 30   // оƒ в«е о.
   energy_resist = 30
   bomb_resist = 30

   to_drop = list(/obj/item/weapon/ore/iron, 6)

/datum/forgotten_beast_mat/plasteel
   name = "plasteel"

   melee_resist = 70   //  уже дробиƒ«€ и разбиваеƒ«€,
   bullet_resist = 50   // но из-за Ѕлазмы в «о«ƒаве
   laser_resist = 40   // чуƒь более у€звима к лазерам.
   energy_resist = 40
   bomb_resist = 50

   to_drop = list(/obj/item/stack/sheet/plasteel, 10)

/datum/forgotten_beast_mat/adamantine
   name = "adamantine"

   melee_resist = 70   // Ѕрочный, ле кий, идеальный.
   bullet_resist = 70   // PRAISE THE MINERS!
   laser_resist = 70
   energy_resist = 70
   bomb_resist = 70

   to_drop = list(/obj/item/stack/sheet/mineral/adamantine, 3)

/datum/forgotten_beast_mat/bananium
   name = "bananium"

   melee_resist = 40   // –едкий  онкий«кий минерал.
   bullet_resist = 40   // Ћуч∆е меƒалла,  уже Ѕла«ƒали.
   laser_resist = 35
   energy_resist = 35
   bomb_resist = 25

   to_drop = list(/obj/item/weapon/ore/bananium, 5)

/datum/forgotten_beast_mat/diamond
   name = "diamond"

   melee_resist = 10   // Ће ко уничƒожаеƒ«€ ударами,
   bullet_resist = 5   // Ѕрево« одно оƒражаеƒ и ЅроЅу«каеƒ
   laser_resist = 80   // «квозь «еб€ лазеры.
   energy_resist = 80
   bomb_resist = 0

   to_drop = list(/obj/item/weapon/ore/diamond, 5)

/datum/forgotten_beast_mat/gold
   name = "gold"

   melee_resist = 25   // ћ€ кий меƒалл, ле ко
   bullet_resist = 20   // разру∆аемый.
   laser_resist = 25
   energy_resist = 25
   bomb_resist = 15

   to_drop = list(/obj/item/weapon/ore/gold, 4)

/datum/forgotten_beast_mat/mythril
   name = "mythril"

   melee_resist = 70   // Ќикƒо не знаеƒ, чƒо эƒо
   bullet_resist = 70   // ƒакое, Ѕоэƒому Ѕу«ƒь оно
   laser_resist = 70   // будеƒ как адаманƒин.
   energy_resist = 70
   bomb_resist = 70

   to_drop = list(/obj/item/stack/sheet/mineral/mythril, 3)

/datum/forgotten_beast_mat/plasma
   name = "plasma"

   melee_resist = 30   // ћне кажеƒ«€, оно должно взрываƒь«€,
   bullet_resist = 25   // Ѕричем взрываƒь«€ ∆умно и ве«ело.
   laser_resist = 10
   energy_resist = 10
   bomb_resist = 5

   to_drop = list(/obj/item/weapon/ore/plasma, 4)

/datum/forgotten_beast_mat/silver
   name = "silver"

   melee_resist = 30   // „уƒь Ѕрочнее золоƒа.
   bullet_resist = 20
   laser_resist = 25
   energy_resist = 25
   bomb_resist = 15

   to_drop = list(/obj/item/weapon/ore/silver, 4)

/datum/forgotten_beast_mat/uranium
   name = "uranium"

   melee_resist = 30   // «редне«ƒаƒиче«кий меƒалл.
   bullet_resist = 25   // ƒолько на не о как-ƒо дей«ƒвуеƒ
   laser_resist = 30   // радиаци€. ћа и€ ко«мо«а.
   energy_resist = 30
   bomb_resist = 10
   rad_resist = 45

   to_drop = list(/obj/item/weapon/ore/uranium, 3)

/datum/forgotten_beast_mat/chitin
   name = "chitin shell"

   melee_resist = 20   // ¬ива л€ к«енобл€ди!
   bullet_resist = 15   // я не знаю, чƒо вы будеƒе « эƒим делаƒь, но вы наверн€ка Ѕридумаеƒе.
   laser_resist = 20
   energy_resist = 20
   bomb_resist = 5
   rad_resist = 20

   to_drop = list(/obj/item/stack/sheet/xenochitin, 1)
