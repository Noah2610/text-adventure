
def add_item (item)
	ITEMS.each do |row|
		if (row[0][0] == item)
			$inventory.push [row[0],row[1].new(row[2])]
			return true
		end
	end
	throw "Couldn't add_item: #{item} (#{item.class})"
end

def rm_item (item)
	$inventory.each_with_index do |row,i|
		if (row[0][0] == item)
			$inventory.delete_at i
			return true
		end
	end
	return false
	throw "Couldn't rm_item: #{item} (#{item.class})"
end

def has_item? (item)
	ITEMS.each do |row|
		return true  if (row[0][0] == item)
	end
	return false
end

def get_input
	return gets.downcase.delete("'.,!?-").split(" ")
end

def convert_symbol (sym)
	return sym.to_s.downcase.gsub("_"," ")
end

def find_item (item)
	ITEMS.each do |row|
		return row[1].new  if (row[0][0] == item)
	end
	return false
end

def find_area (area)
	AREAS.each do |row|
		return row[1]  if (row[0][0] == area)
	end
	return false
end

def find_person (person)
	PEOPLE.each do |row|
		return row[1]  if (row[0][0] == person)
	end
	return false
end

def find_areaObject (aobj)
	AREA_OBJECTS.each do |row|
		return row[1]  if (row[0][0] == aobj)
	end
	return false
end

def find_instance (instance)
	return find_item(instance) || find_area(instance) || find_person(instance) || find_areaObject(instance) || false
end

# if given symbol is any name of any instance
# then return the main identifier symbol of instance
def is_instance_sym? (instance)
	Array.new.concat(ITEMS,AREAS,PEOPLE,AREA_OBJECTS).each do |irow|
		irow[0].each do |iname|
			if (iname == instance)
				return irow[0][0]
			end
		end
	end
	return false
end

