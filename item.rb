


class Item

	def initialize
		@default_use      = "That doesn't seem to work."
		@default_use_with = "Thoes don't seem to work together."
		@name = @description = "NONE"
	end

	def describe
		@description
	end

end



class Test_item < Item

	def initialize
		@name = "Test Item"
		@description = "This is a test item.\nIt looks as if it's sole purpose is functionality testing."
	end

end


ITEMS = [
	[[:test_item,:testitem,:item], Test_item.new]
]

