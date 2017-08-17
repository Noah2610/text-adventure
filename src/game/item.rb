
class Joint_item < Item
	def init
		@name = "Joint".blue
		@desc_passive = "It's a rolled-up #{@name}.".italic
		@desc = "It smells pretty intense,\n".italic +
						"I think whoever rolled it probably didn't use any tobacco.".italic
	end
end
