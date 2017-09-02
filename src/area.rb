
class Area < Instance
	attr_accessor :neighbors, :items, :people, :area_objects, :has_visited, :events
	def initialize_instance (*args)
		@name = "area_name"
		@desc = "Default Area description."
		@desc_passive = "Default passive Area description."
		@neighbors = []
		@items = []
		@people = []
		@area_objects = []
		@has_visited = false
		@events = []
		@to_save.push(:items, :has_visited)
		self.init
	end
	def goto!
		$area = self
		@neighbors = AREA_MAP[to_sym] || []
		ret = []
		ret.push goto
		@has_visited = true
		return ret.join("\n")
	end
	def goto
		if (!@has_visited)
			ret = []
			first = first_visit
			ret.push first  if first
			ret.push look
			return ret.join("\n")
		elsif (@has_visited)
			return @name
		end
	end
	def first_visit
		return false
	end
	def Area.goto (area)
		$area.neighbors.each do |ngb|
			AREAS.each do |row|
				next  unless (row[0][0] == ngb)
				#$area = row[1]
				#$area.has_visited = true
				row[1].goto!
			end
		end
	end
	def Area.goto! (area)
		#$area = find_area area
		#$area.has_visited = true
		find_area(area).goto!
	end
end


require_relative "dev/area"
require_relative "game/area"


class Instance
	def is_item?
		ITEMS.each do |item|
			return true  if (item[0][0] == self.to_sym)
		end
		return false
	end
	def is_area?
		AREAS.each do |area|
			return true  if (area[0][0] == self.to_sym)
		end
		return false
	end
	def is_person?
		PEOPLE.each do |area|
			return true  if (area[0][0] == self.to_sym)
		end
		return false
	end
	def is_areaObject?
		AREA_OBJECTS.each do |aobj|
			return true  if (aobj[0][0] == self.to_sym)
		end
		return false
	end
end

