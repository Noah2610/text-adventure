
class Glove_compartment_Aobj < Area_object
	def init (args=[])
		@name = "Glove Compartment".blue
		@desc_default = "Just a regular #{@name}"
		@desc = @desc_default
		@items = [:joint]
		@item_descs = {
			joint: "There's a #{find_item(:joint).name} inside."
		}
		@is_open = false
	end

	def open
		unless (@is_open)
			@is_open = true
			#@desc = @desc + ""  unless (@items.empty?)
			ret = []
			ret.push "I opened the #{@name}."
			@items.each do |item|
				ret.push @item_descs[item]
			end
			return ret.join "\n"
		else
			return "It's already open."
		end
	end

	def close
		if (@is_open)
			@is_open = false
			@desc = @desc_default
			return "I closed the #{@name}."
		else
			return "It's already closed."
		end
	end

end

