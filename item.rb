
class Item < Instance
	attr_accessor :name

	def initialize (args=[])
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
		return false  if (@args.empty?)
		@args.each do |a|
			if (a == arg)
				return true
				break
			end
		end
		return false
	end

	def look
		$inventory.each do |item|
			if (item[1] == self)
				return @desc
			end
		end
		#return "test"
		return @desc_passive
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



class Test_item < Item
	def init
		@name = "Test Item".red
		@desc = "This is a #{@name}.\nIt looks as if it's sole purpose is functionality testing."
	end
end

class Foo < Item
	def init
		@name = "Foo".yellow
		@desc = "FOoobar barfoo"
		@desc_passive = "fooo's passive description"
	end
end

class Bar < Item
	def init
		@name = "Bar".blue
		@desc = "Hello".green + " World".yellow
		@desc_passive = "Bar passive yo yo yo"
	end
end


ITEMS = [
	[[:inventory,:inv], Inventory, [:an]],
	[[:test_item,:testitem,:item], Test_item, []],
	[[:foo], Foo, []],
	[[:bar], Bar, []]
]


def add_item(item)
	ITEMS.each do |row|
		if (row[0][0] == item.to_sym)
			$inventory.push [row[0],row[1].new(row[2])]
		end
	end
end

