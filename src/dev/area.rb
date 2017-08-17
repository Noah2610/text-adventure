
class Starting_area < Area
	def init
		@name = "Starting Area".blue
		@desc = "This is the starting area, only for development though.\n".italic +
						"I can see a #{"person".blue} and a #{"box".cyan}.".italic
		@desc_passive = "I think that's the #@name I came from."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
		@people = [:test_person]
		@area_objects = [:box]
	end
end

class Start_rm_2 < Area
	def init
		@name = "Test Area 2".blue
		@desc = "This is the second test area.\nFoo and Bar lie here."
		@desc_passive = "Looks like another test area."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
		@items = [:foo,:bar]
	end
end

class Hall_area < Area
	def init
		@name = "Hallway".red
		@desc_passive = "It looks like a very dark and long hallway."
		@desc = "There area lots of doors to the left and right,\nthe light is very dim in here."
		@neighbors = []
	end
end

class Hall_room_left < Area
	def init
		@name = "Left Room - Hallway".blue
		@desc_passive = "I can't see anything from here,\nthe room is way too dark."
		@desc_noaccess = "Hm, it seems even darker in here.\nMaybe I can find some portable source of light."
		@desc = "Ah, I can see this room more clearly now.\nThere seems to be some #{"human-like figure".green} standing in the back.\nHe looks creepy..."
		@neighbors = []
		@people = [:crazy_person]
	end

	def goto
		if (has_item? :torch)
			@people = [:crazy_person]  unless (@people[0] == :crazy_person)
			return @desc
		else
			return @desc_noaccess
		end

		#look_at_arr = ["Ceiling".light_black,"Floor".blue,"Run Away".yellow].shuffle
		#output = ["Where should I look to first?".italic]
		#look_at_arr.each do |spot|
			#output.push spot
		#end
		#puts output.join("\n")
		#input = get_input
		#if (input.include? "ceiling")
			#return "The " + "Ceiling".light_black + " is very dark."
		#elsif (input.include? "floor")
			#return "The " + "Floor".blue + " has more to come!"
		#elsif (input.include? "run")
			#Area.goto :hallway
			#return "I " + "Run Away".yellow + " screaming like a little child."\
						 #"\n...".bold + "\nI'm a real scardy-cat..."
		#end

	end
end
class Hall_room_right < Area
	def init
		@name = "Right Room - Hallway".blue
		@desc = "Right Hallway Room Description"
		@neighbors = []
	end
end

