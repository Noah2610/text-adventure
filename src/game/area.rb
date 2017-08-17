
class Truck_area < Area
	def init
		@name = "Parsley's Truck".blue.italic
		@desc = "This is #{@name}, he has a weird obsession about it.\nIt's pretty scratched up and dirty.\n" +
						"I really don't appreciate the smell.\n" +
						"#{"Parsley".green} seems to have passed out in the driver's seat.\n" +
						"Well, we might have some more drugs in the car to spend the time.\n" +
						"Although I really need to go pee."
		@desc_passive = "#{@name} looks even worse from the outside."
		@people = [:parsley_person]
		@neighbors = AREA_MAP[:truck]
		@area_objects = [:glove_compartment]
	end

end

class Cornfield_area < Area
	def init
		@name = "Cornfield".yellow
		@desc = "Some parts of the cornfield have been trampled.\nWas that #{"Parsley".green} driving through the field on whatever drugs we were on?".italic +
						"Well, I really need to take a #{"piss".blue} now."
		@desc_passive = "It's too dark outside, I can't see a thing.".italic
		@neighbors = AREA_MAP[:truck]
		@events = [
			[:pee,:toilet,:piss,:wc]
		]
	end

	def pee
		return "I am peeing, aliens should arrive now."
	end
end

