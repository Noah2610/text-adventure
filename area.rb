
class Area < Instance
	attr_accessor :name, :neighbors, :items, :people, :has_visited
	def initialize_instance (*args)
		@name = "area_name"
		@desc = "Default Area description."
		@desc_passive = "Default passive Area description."
		@neighbors = []
		@items = []
		@people = []
		@has_visited = false
		self.init
	end
	def goto!
		$area = self
		@neighbors = AREA_MAP[to_sym]
		ret = []
		ret.push goto
		@has_visited = true
		return ret
	end
	def goto
		if (!@has_visited)
			return look
		elsif (@has_visited)
			return @name
		end
	end
	def Area.goto (area)
		$area.neighbors.each do |ngb|
			AREAS.each do |row|
				next  unless (row[0][0] == ngb)
				$area = row[1]
				$area.has_visited = true
			end
		end
	end
	def look
		return "#{@name}\n#{@desc}"  if ($area == self)
		return @desc_passive
	end
end


class Starting_area < Area
	def init
		@name = "Starting Area".blue
		@desc = "This is the starting area, only for development though."
		@desc_passive = "I think that's the #@name I came from."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
		@people = [:test_person]
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


AREA_MAP = {
	starting_area: [ :start_rm_2, :hallway ],
	start_rm_2: [ :starting_area ],
	hallway: [ :starting_area, :hall_room_left, :hall_room_right ],
		hall_room_right: [ :hallway ],  # :secret_room
		hall_room_left: [ :hallway ],
}

AREAS = [
	[[:starting_area,:start_area,:area], Starting_area.new],
	[[:start_rm_2,:area2], Start_rm_2.new],
	[[:hallway,:hall], Hall_area.new],
		[[:hall_room_left,:room_left,:left_room], Hall_room_left.new],
		[[:hall_room_right,:room_right,:right_room], Hall_room_right.new]
		

]

class Instance
	def is_item?
		ITEMS.each do |item|
			if (item[1] == self.class)
				return true
			end
		end
		return false
	end
	def is_area?
		AREAS.each do |area|
			if (area[1] == self)
				return true
			end
		end
		return false
	end
	def is_person?
		PEOPLE.each do |area|
			if (area[1] == self)
				return true
			end
		end
		return false
	end
end

