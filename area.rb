
AREA_MAP = {
	starting_area: [ :start_rm_2 ],
	start_rm_2: [ :starting_area ]
}


class Area < Instance
	attr_accessor :name, :neighbors, :items, :people, :has_visited
	def initialize_instance (*args)
		@name = "area_name"
		@desc = "Default Area description."
		@neighbors = []
		@items = []
		@people = []
		@has_visited = false
		self.init
	end
	def goto!
		$area = self
		@has_visited = true
	end
end


class Starting_area < Area
	def init
		@name = "Starting Area".blue
		@desc = "This is the starting area, only for development though."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
		@people = [:test_person]
	end
end

class Start_rm_2 < Area
	def init
		@name = "Test Area 2".blue
		@desc = "This is the second test area.\nFoo and Bar lie here."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
		@items = [:foo,:bar]
	end
end


AREAS = [

	[[:starting_area,:start_area,:area], Starting_area.new],
	[[:start_rm_2,:area2], Start_rm_2.new]

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

