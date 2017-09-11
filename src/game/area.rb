
class Truck_area < Area
	def init
		@people = [:parsley]
		#@neighbors = AREA_MAP[:truck]
		@area_objects = [:glove_compartment]
		@items = [:test_item]
	end
end

class Cornfield_area < Area
	def init
		#@neighbors = AREA_MAP[:truck]
		@events = [
			[:pee,:toilet,:piss,:wc]
		]
	end

	def pee
		output "I am peeing, aliens should arrive now."
		return Area.goto!(:spaceship_abduct)
	end
end

class Spaceship_abduct_area < Area
	def init
		@people = [:aliens_abduct]
		#@neighbors = AREA_MAP[:spaceship_abduct]
	end
end

class Window_abduct_area < Area
	def init
		#@neighbors = AREA_MAP[:window_abduct]
	end
end

class Bridge_abduct_area < Area
	def init
		#@neighbors = AREA_MAP[:bridge_abduct]
		@area_objects = [:console_abduct]
	end
end

class Lounge_abduct_area < Area
	def init
		#@neighbors = AREA_MAP[:lounge_abduct]
		@area_objects = [:sofa_abduct]
	end
end


# spaceship cell
class Cell_abduct_area < Area
	def init
		@area_objects = [:cell_bed_abduct,:cell_wall_abduct,:cell_door_abduct]
		@people = [:guard_abduct]
		@events = [
			[:sleep]
		]
		@to_save.push :neighbors
	end
	def sleep
		return find_areaObject(:cell_bed_abduct).use
	end
end

# cell area - hallway
class Corridor_abduct_area < Area
	def init
		@people = [:guard_abduct,:prisoner_abduct]
		@area_objects = [:other_cell_door_abduct]
	end

	def goto_area
		# return Array with [0] => true|false (can goto or not)
		# [1] => text if [0] is false (cannot goto)
		cell_door = find_areaObject(:cell_door_abduct)
		if (cell_door.is_open)
			return [true]
		elsif (cell_door.is_locked)
			return [false, @text[:open_locked_door]]
		elsif (!cell_door.is_locked)
			return [false, @text[:open_unlocked_closed_door]]
		end
	end
end

# other cell, with prisoner in it
class OtherCell_abduct_area < Area
	def init
		@people = [:prisoner_abduct]
		@area_objects = [:other_cell_door_abduct]
	end

	def goto_area
		# return Array with [0] => true|false (can goto or not)
		# [1] => text if [0] is false (cannot goto)
		other_cell_door = find_areaObject(:other_cell_door_abduct)
		if (other_cell_door.is_open)
			return [true]
		elsif (other_cell_door.is_locked)
			return [false, @text[:open_locked_door]]
		elsif (!other_cell_door.is_locked)
			return [false, @text[:open_unlocked_closed_door]]
		end
	end
end

