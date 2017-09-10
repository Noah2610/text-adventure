
class Area_object < Instance
	attr_accessor :is_open, :items

	def initialize_instance (args=[])
		@name = "Default Area_object name."
		@desc = "Default Area_object description."
		@desc_passive = "Default passive Area_object description."
		@items = []
		@args = args
		#@to_save.push :items
		self.init# args
	end

	def take
		ret = []
		if (@is_open)
			@items.each do |item|
				@items.delete item
				add_item item
				ret.push "I took #{$inventory[-1][1].name}"
			end
		end
		return ret.join("\n")  unless ret.empty?
		return "There's nothing to take here."
	end
end


require_relative "./dev/area_object"
require_relative "./game/area_object"

