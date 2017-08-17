
def find_item (item)
	ITEMS.each do |row|
		return row[1].new  if (row[0][0] == item)
	end
	return false
end

def find_area (area)
	AREA.each do |row|
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

