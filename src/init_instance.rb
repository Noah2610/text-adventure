
AREA_MAP = {
	starting_area: [ :start_rm_2, :hallway ],
	start_rm_2: [ :starting_area ],
	hallway: [ :starting_area, :hall_room_left, :hall_room_right ],
		hall_room_right: [ :hallway ],  # :secret_room
		hall_room_left: [ :hallway ],

	truck: [ :cornfield ],
	cornfield: [ :truck ],

	spaceship_abduct: [ :window_abduct ],
	window_abduct: [ :spaceship_abduct ]
}


ITEMS = [
	[[:inventory,:inv], Inventory, [:an]],
	[[:test_item,:testitem,:item], Test_item, []],
	[[:foo], Foo, [:an]],
	[[:bar], Bar, []],
	[[:apple], Apple, [:an]],

	[[:joint,:weed,:gras,:doobie], Joint_item, []]
]


AREAS = [
	[[:starting_area,:start_area,:area], Starting_area.new],
	[[:start_rm_2,:area2], Start_rm_2.new],
	[[:hallway,:hall], Hall_area.new],
		[[:hall_room_left,:room_left,:left_room], Hall_room_left.new],
		[[:hall_room_right,:room_right,:right_room], Hall_room_right.new],

	[[:truck,:car], Truck_area.new],
	[[:cornfield,:outside,:out], Cornfield_area.new],

	[[:spaceship_abduct,:ship], Spaceship_abduct_area.new],
	[[:window_abduct], Window_abduct.new]
]


PEOPLE = [
	[[:test_person,:person], Test_person.new],
	[[:crazy_person,:human_like_figure,:figure], Crazy_person.new],

	[[:parsley,:friend], Parsley_person.new],
	[[:aliens_abduct], Aliens_abduct_person.new]
]


AREA_OBJECTS = [
	[[:box], Box_Aobj.new],

	[[:glove_compartment,:glove_box,:cubby_hole], Glove_compartment_Aobj.new]
]

