
class Truck_area < Area
	def init
		@people = [:parsley,:test_person]
		#@neighbors = AREA_MAP[:truck]
		@area_objects = [:glove_compartment]
	end
end

class Cornfield_area < Area
	def init
		@neighbors = AREA_MAP[:truck]
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
		@neighbors = [:bridge_abduct,:window_abduct]
	end
end

class Window_abduct < Area
	def init
		@neighbors = [:spaceship_abduct]
	end
end

class Bridge_area < Area
	def init
		@neighbors = [:spaceship_abduct]
		@area_objects = [:console_abduct]
	end
end

