
class Truck_area < Area
	def init
		@name = "Parsley's Truck".blue
		@people = [:parsley_person]
		@neighbors = AREA_MAP[:truck]
		@area_objects = [:glove_compartment]
	end

end

class Cornfield_area < Area
	def init
		@name = "Cornfield".yellow
		@desc = "Some parts of the cornfield have been trampled.\nWas that #{"Parsley".green} driving through the field on whatever drugs we were on?\n" +
						"Well, I really need to take a #{"piss".blue} now."
		@desc_passive = "It's too dark outside, I can't see a thing."
		@neighbors = AREA_MAP[:truck]
		@events = [
			[:pee,:toilet,:piss,:wc]
		]
	end

	def pee
		return "I am peeing, aliens should arrive now."
	end
end

