
AREA_MAP = {
	starting_area: [ :start_rm_2 ],
	start_rm_2: [ :starting_area ]
}


class Area < Instance
	attr_accessor :items

	def initialize
		@desc = "This is an area."
		@neighbors = []
		@items = []
		self.init
	end
end


class Starting_area < Area
	def init
		@desc = "This is the starting area, only for development though."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
	end
end

class Start_rm_2 < Area
	def init
		@desc = "This is the second test area.\nFoo and Bar lie here."
		@neighbors = AREA_MAP[self.class.to_s.downcase.to_sym]
		@items = [:foo,:bar]
	end
end


AREAS = [

	[[:starting_area,:start_area,:area], Starting_area.new],
	[[:start_rm_2,:area2], Start_rm_2.new]

]

