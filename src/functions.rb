
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

def clear_inventory
	$inventory = []
end

def has_item? (item)
	$inventory.each do |row|
		return true  if (row[0][0] == item)
	end
	return false
end

def get_input
	#return gets.downcase.delete("'.,!?-").split(" ")
	input = ""
	while ( input == "" )
		input = File.read($input).strip
		sleep 0.1
	end
	file = File.new($input,"w")
	file.print("")
	file.close
	return input.downcase.delete("'.,!?-").split(" ")
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
		row[1].get_text
		return row[1]  if (row[0][0] == area)
	end
	return false
end

def find_person (person)
	PEOPLE.each do |row|
		row[1].get_text
		return row[1]  if (row[0][0] == person)
	end
	return false
end

def find_areaObject (aobj)
	AREA_OBJECTS.each do |row|
		row[1].get_text
		return row[1]  if (row[0][0] == aobj)
	end
	return false
end

def find_instance (instance)
	return find_item(instance) || find_area(instance) || find_person(instance) || find_areaObject(instance) || false
end

# if given symbol is any name of any instance
# then return the main identifier symbol of instance
# NOT USED ANYMORE / DEPRECATED
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

def output (text)
	puts " " + text.gsub("\n","\n  ")
end

def save_game (savefile=$current_savefile)
	Dir.mkdir($savedir)  unless (Dir.exists?($savedir))
	$current_savefile = savefile  if (savefile != $current_savefile)
	#savefile = savefile + ".rb"  if (savefile[-3..-1] != ".rb")
	inventory_items = []
	$inventory.each do |row|
		inventory_items.push row[0][0]
	end
	save_data = {
		current_area: $area.to_sym,
		inventory_items: inventory_items
	}
	Array.new.concat($inventory,AREAS,PEOPLE,AREA_OBJECTS).each do |inst|
		instance = inst[1]
		save_hash = instance.save
		save_data[instance.to_sym] = save_hash  unless (save_hash.empty?)
	end
	save_data_encrypted = Encrypt.dump(save_data.to_s, $encrypt_password)
	file = File.new($savedir + savefile,"w")
	file.print save_data_encrypted
	file.close
	return "Game saved to '#{savefile}'!"
end

def load_game (savefile=$current_savefile)
	#savefile = savefile + ".rb"  if (savefile[-3..-1] != ".rb")
	return "File '#{savefile}' not found."  unless (File.exists?($savedir + savefile))
	$current_savefile = savefile  if (savefile != $current_savefile)
	save_data_encrypted = File.read($savedir + savefile)
	save_data = eval(Encrypt.load(save_data_encrypted, $encrypt_password))
	Area.goto! save_data[:current_area]
	clear_inventory
	save_data[:inventory_items].each do |item|
		add_item item
	end
	Array.new.concat($inventory,AREAS,PEOPLE,AREA_OBJECTS).each do |inst|
		instance = inst[1]
		instance.load(save_data[instance.to_sym])  if (save_data[instance.to_sym])
	end
	output "Game loaded from '#{savefile}'!"
	return $area.look
end

def gen_new_savefile
	saves = Dir.entries($savedir)
	saves.delete "."
	saves.delete ".."
	hi_num = 0
	saves.each do |file|
		hi_num = file.delete("save").to_i  if (file[0..3] == "save" && file.delete("save").to_i > hi_num)
	end
	return "save#{(hi_num + 1).to_s}"
end

