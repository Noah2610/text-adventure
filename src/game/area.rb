
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

