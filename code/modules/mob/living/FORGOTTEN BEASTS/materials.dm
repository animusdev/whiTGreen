/datum/forgotten_beast_mat  //  Материалы  для  конечностей  забытых  тварей  со  всеми  параметрами.
	var/name  =  "genericium"

	var/melee_resist  =  0  	//  Получаемый  урон  высчитывается  как  DAMAGE  *  (1  -  RESIST  /  100),
	var/bullet_resist  =  0	//  то  есть  RESIST  определяет  количество  урона  в  процентах,
	var/laser_resist  =  0	//  который  будет  отражен.
	var/energy_resist  =  0
	var/bomb_resist  =  0
	var/rad_resist  =  100	//  Ебени  из  чистого  золота  не  страшна  радиация,  верно?

	var/to_drop  =  list(/obj/item/weapon/ore,  1)	//  Руда,  которая  выпадает  после  разрушения  конечности.

	var/limb_color  =  rgb(150,  150,  150)

/datum/forgotten_beast_mat/sand
	name  =  "sand"

	melee_resist  =  15	//  Песок  легко  разрушается  ударами,
	bullet_resist  =  5	//  но  лазер  плавит  его  и  наносит
	laser_resist  =  20	//  меньше  урона.
	energy_resist  =  20

	to_drop  =  list(/obj/item/weapon/ore/glass,  8)

/datum/forgotten_beast_mat/metal
	name  =  "metal"

	melee_resist  =  50	//  Среднестатический  материал.
	bullet_resist  =  30	//  Не  очень  хорош,  но  защищает
	laser_resist  =  30	//  от  всего.
	energy_resist  =  30
	bomb_resist  =  30

	to_drop  =  list(/obj/item/weapon/ore/iron,  6)

/datum/forgotten_beast_mat/plasteel
	name  =  "plasteel"

	melee_resist  =  70	//  Хуже  дробится  и  разбивается,
	bullet_resist  =  50	//  но  из-за  плазмы  в  составе
	laser_resist  =  40	//  чуть  более  уязвима  к  лазерам.
	energy_resist  =  40
	bomb_resist  =  50

	to_drop  =  list(/obj/item/stack/sheet/plasteel,  10)

/datum/forgotten_beast_mat/adamantine
	name  =  "adamantine"

	melee_resist  =  70	//  Прочный,  легкий,  идеальный.
	bullet_resist  =  70	//  PRAISE  THE  MINERS!
	laser_resist  =  70
	energy_resist  =  70
	bomb_resist  =  70

	to_drop  =  list(/obj/item/stack/sheet/mineral/adamantine,  3)

/datum/forgotten_beast_mat/bananium
	name  =  "bananium"

	melee_resist  =  40	//  Редкий  хонкийский  минерал.
	bullet_resist  =  40	//  Лучше  металла,  хуже  пластали.
	laser_resist  =  35
	energy_resist  =  35
	bomb_resist  =  25

	to_drop  =  list(/obj/item/weapon/ore/bananium,  5)

/datum/forgotten_beast_mat/diamond
	name  =  "diamond"

	melee_resist  =  10	//  Легко  уничтожается  ударами,
	bullet_resist  =  5	//  превосходно  отражает  и  пропускает
	laser_resist  =  80	//  сквозь  себя  лазеры.
	energy_resist  =  80
	bomb_resist  =  0

	to_drop  =  list(/obj/item/weapon/ore/diamond,  5)

/datum/forgotten_beast_mat/gold
	name  =  "gold"

	melee_resist  =  25	//  Мягкий  металл,  легко
	bullet_resist  =  20	//  разрушаемый.
	laser_resist  =  25
	energy_resist  =  25
	bomb_resist  =  15

	to_drop  =  list(/obj/item/weapon/ore/gold,  4)

/datum/forgotten_beast_mat/mythril
	name  =  "mythril"

	melee_resist  =  70	//  Никто  не  знает,  что  это
	bullet_resist  =  70	//  такое,  поэтому  пусть  оно
	laser_resist  =  70	//  будет  как  адамантин.
	energy_resist  =  70
	bomb_resist  =  70

	to_drop  =  list(/obj/item/stack/sheet/mineral/mythril,  3)

/datum/forgotten_beast_mat/plasma
	name  =  "plasma"

	melee_resist  =  30	//  Мне  кажется,  оно  должно  взрываться,
	bullet_resist  =  25	//  причем  взрываться  шумно  и  весело.
	laser_resist  =  10
	energy_resist  =  10
	bomb_resist  =  5

	to_drop  =  list(/obj/item/weapon/ore/plasma,  4)

/datum/forgotten_beast_mat/silver
	name  =  "silver"

	melee_resist  =  30	//  Чуть  прочнее  золота.
	bullet_resist  =  20
	laser_resist  =  25
	energy_resist  =  25
	bomb_resist  =  15

	to_drop  =  list(/obj/item/weapon/ore/silver,  4)

/datum/forgotten_beast_mat/uranium
	name  =  "uranium"

	melee_resist  =  30	//  Среднестатический  металл.
	bullet_resist  =  25	//  Только  на  него  как-то  действует
	laser_resist  =  30	//  радиация.  Магия  космоса.
	energy_resist  =  30
	bomb_resist  =  10
	rad_resist  =  45

	to_drop  =  list(/obj/item/weapon/ore/uranium,  3)

/datum/forgotten_beast_mat/chitin
	name  =  "chitin  shell"

	melee_resist  =  20	//  Вива  ля  ксенобляди!
	bullet_resist  =  15	//  Я  не  знаю,  что  вы  будете  с  этим  делать,  но  вы  наверняка  придумаете.
	laser_resist  =  20
	energy_resist  =  20
	bomb_resist  =  5
	rad_resist  =  20

	to_drop  =  list(/obj/item/stack/sheet/xenochitin,  1)
