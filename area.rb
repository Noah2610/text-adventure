
AREAS = {

	test_area: {
		rm1: []
	}

}


class Area
	def initialize
		@desc = "This is an area."
	end

	def describe
		@desc
	end
end


class Starting_area < Area
	def initialize
		@desc = "This is the starting area, only for development though."
	end
end
