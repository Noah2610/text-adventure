
class Box_Aobj < Area_object
	def init (args=[])
		@name = "Box".cyan
		@desc_default = "Looks like a regular old box.".italic
		@desc = @desc_default
		@items = [:apple]
		@is_open = false
	end

	def open
		ret = []
		unless (@is_open)
			@is_open = true
			ret.push "I opened the #{@name}."
			ret.push "There seems to be something inside."
			@desc += "\nThere seems to be something inside.".italic
		else
			ret.push "It's already open."
		end
		return ret.join("\n")
	end

	def close
		ret = []
		if (@is_open)
			@is_open = false
			ret.push "I closed the #{@name}."
			@desc = @desc_default
		else
			ret.push "It's already closed."
		end
		return ret.join("\n")
	end

	def take
		if (@is_open)
			if (!@items.empty?)
				@desc = @desc_default + "\nThere used to be an apple inside.".italic
				add_item @items[0]
				@items.delete_at 0
				str = "There was"
				if ($inventory.last[1].has_arg?(:an))
					str += " an "
				else
					str += " a "
				end
				str += $inventory.last[1].name + " inside."
				return str
			end
			return ""
		else
			return "I should probably open it first."
		end
	end
end

