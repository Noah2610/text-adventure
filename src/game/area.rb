
class Truck_area < Area
	def init
		@name = "Parsley's Truck".blue
		@people = [:parsley]
		@neighbors = AREA_MAP[:truck]
		@area_objects = [:glove_compartment]
	end

end

class Cornfield_area < Area
	def init
		@name = "Cornfield".yellow
		@neighbors = AREA_MAP[:truck]
		@events = [
			[:pee,:toilet,:piss,:wc]
		]
	end

	def pee
		return "I am peeing, aliens should arrive now."
	end
end

