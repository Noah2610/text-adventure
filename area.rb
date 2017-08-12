
AREA_MAP = {
	starting_area: [ :start_rm_2 ],
	start_rm_2: [ :starting_area ]
}


class Area < Instance
	def initialize
		@desc = "This is an area."
		@neighbors = []
	end
end


class Starting_area < Area
	def initialize
		@desc = "This is the starting area, only for development though."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
	end
end

class Start_rm_2 < Area
	def initialize
		@desc = "This is the second test area."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
	end
end


AREAS = [

	[[:starting_area,:start_area,:area], Starting_area.new],
	[[:start_rm_2,:area2], Start_rm_2.new]

]

