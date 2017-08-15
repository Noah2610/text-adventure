
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
		@has_visited = true
		@neighbors = AREA_MAP[to_sym]
		#self.goto
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
		@desc = "There area lots of doors to the left and right,\nthe light is very dim in here."
		@neighbors = []
	end
end

class Hall_room_left < Area
	def init
		@name = "Left Room".blue
		@desc_passive = "Hm, it seems even darker in here.\nMaybe I can find some portable source of light."
		@desc = "Ah, I can see this room more clearly now."
		
		@neighbors = []
	end

	def goto
		sleep 1
		look_at_arr = ["Ceiling".black,"Floor".blue,"Run Away".yellow].shuffle
		output = ["Where should I look to first?"]
		look_at_arr.each do |spot|
			output.push spot
		end
		puts output.join("\n")
		input = get_input
		case (input.include?)
		when "ceiling"
			return "The " "Ceiling".black " is very dark."
		when "floor"
			return "The " "Floor".blue " has more to come!"
		when "run"
			Area.goto :hallway
			return "I " "Run Away".yellow " screaming like a little child."\
						 "\n...".bold "\nI'm a real scardy-cat..."
		end

	end
end
class Hall_room_right < Area
	def init
		@name = "Hallway".red
		@desc = "There area lots of doors to the left and right,\nthe light is very dim in here."
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
		[[:hall_room_left], Hall_room_left.new],
		[[:hall_room_right], Hall_room_right.new]
		

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

