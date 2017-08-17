
class Item < Instance
	def initialize_instance (args=[])
		#@default_use      = "That doesn't seem to work."
		#@default_use_with = "Thoes don't seem to work together."
		#@name = "item_name"
		@desc = "item_desc"
		@desc_passive = "item_desc_passive"
		@name = "Default Item name"
		@args = args
		self.init
	end

	def has_arg? (arg)
		@args.each do |a|
			if (a == arg)
				return true
			end
		end
		return false
	end

	def look
		#$inventory.each do |item|
			#if (item[1] == self)
				#return "#{@name}\n#{@desc}"
			#end
		#end
		return "#{@name}\n#{@desc}".italic  if (self.in_inv?)
		return @desc_passive.italic
	end

	def take
		"Took the #{@name}."
	end

	def in_inv?
		#ap $inventory
		$inventory.each do |row|
			if (row[0][0] == self.to_sym)
				return true
			end
		end
		return false
	end

end


class Inventory < Item
	def init
		@desc = "Inventory description."
		@desc_passive = "Crappy bag that can carrys stuff."
		@name = "Inventory (item)"
	end

	def look
		ret = "You have\n"
		$inventory.each_with_index do |item,i|
			next  if (item[0][0] == :inventory)
			if (item[1].has_arg?(:an))
				ret += "an "
			else
				ret += "a "
			end
			ret += item[1].name
			ret += ",\n"  unless (i == $inventory.length - 1)
		end
		return ret + "."
	end
end


require_relative "./dev/item"
require_relative "./game/item"

