
class Glove_compartment_Aobj < Area_object
	def init (args=[])
		@items = [:joint]
		@is_open = false
	end

	def open
		unless (@is_open)
			@is_open = true
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
			return "I closed the #{@name}."
		else
			return "It's already closed."
		end
	end

end

class Console_abduct < Area_object
	def init (args=[])
		@turned_on = false
	end
	def use
		return @text[:use_turned_off]  unless (@turned_on)
		return "use console"
	end
	def look_additional
		unless (@turned_on)
			return @text[:turned_off]
		else
			return @text[:turned_on]
		end
	end
	
	def turn_on
		@turned_on = true
		return @text[:after_turn_on]
	end
	def turn_off
		@turned_on = false
		return @text[:after_turn_off]
	end

end

