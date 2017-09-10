
AREA_MAP = {
	starting_area: [ :start_rm_2, :hallway ],
	start_rm_2:    [ :starting_area ],
	hallway:       [ :starting_area, :hall_room_left, :hall_room_right ],
		hall_room_right: [ :hallway ],  # :secret_room
		hall_room_left:  [ :hallway ],

	truck:     [ :cornfield ],
	cornfield: [ :truck ],

	spaceship_abduct: [ :bridge_abduct,:lounge_abduct,:window_abduct ],
	window_abduct:    [ :spaceship_abduct ],
	bridge_abduct:    [ :spaceship_abduct ],
	lounge_abduct:    [ :spaceship_abduct ],

	cell_abduct:            [ ],
		cell_unlocked_abduct: [ :corridor_abduct ],
	corridor_abduct:        [ :cell_abduct,:other_cell_abduct,:window_abduct ],
	other_cell_abduct:      [ :corridor_abduct ]
}


ITEMS = [
	[[:inventory,:inv],            Inventory, [:an]],
	[[:test_item,:testitem,:item], Test_item, []],
	[[:foo],                       Foo, [:an]],
	[[:bar],                       Bar, []],
	[[:apple],                     Apple, [:an]],

	[[:joint,:weed,:gras,:doobie], Joint_item, []],

	# keychain cell_abduct
	[[:keychain_abduct,:keys],     Keychain_cell_abduct_item, []],
	# stick in wall
	[[:stick_abduct],              Stick_abduct_item, []]
]


AREAS = [
	[[:starting_area,:start_area,:area], Starting_area.new],
	[[:start_rm_2,:area2],               Start_rm_2.new],
	[[:hallway,:hall],                   Hall_area.new],
		[[:hall_room_left,:room_left,:left_room],    Hall_room_left.new],
		[[:hall_room_right,:room_right,:right_room], Hall_room_right.new],

	[[:truck,:car],              Truck_area.new],
	[[:cornfield,:outside,:out], Cornfield_area.new],

	[[:spaceship_abduct,:ship], Spaceship_abduct_area.new],
	[[:window_abduct],          Window_abduct_area.new],
	[[:bridge_abduct],          Bridge_abduct_area.new],
	[[:lounge_abduct,:social_area,:community_area,:living_room,:recreational_area],
	                            Lounge_abduct_area.new],

	# cell_abduct
	[[:cell_abduct],                               Cell_abduct_area.new],
	[[:corridor_abduct,:hallway,:prison_corridor], Corridor_abduct_area.new],
	[[:other_cell_abduct],                         OtherCell_abduct_area.new]
]


PEOPLE = [
	[[:test_person,:person],                     Test_person.new],
	[[:crazy_person,:human_like_figure,:figure], Crazy_person.new],

	[[:parsley,:friend], Parsley_person.new],
	[[:aliens_abduct],   Aliens_abduct_person.new],

	[[:guard_abduct,:alien_guard], Guard_abduct_person.new],
	[[:prisoner_abduct,:inmate],   Prisoner_abduct_person.new]
]


AREA_OBJECTS = [
	[[:box], Box_Aobj.new],

	[[:glove_compartment,:glove_box,:cubby_hole],
	         Glove_compartment_areaObject.new],

	[[:console_abduct,:computer,:controller,:command_console],
	         Console_abduct_areaObject.new],

	[[:sofa_abduct,:couch], Sofa_abduct_areaObject.new],

	# cell_abduct
	[[:cell_bed_abduct,:bed,:matress], CellBed_abduct_areaObject.new],
	[[:cell_wall_abduct,:wall,:tile],  CellWall_abduct_areaObject.new],
	[[:cell_door_abduct,:door],        CellDoor_abduct_areaObject.new]
]

