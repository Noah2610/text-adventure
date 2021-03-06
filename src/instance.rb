
class Instance
	attr_accessor :name, :desc, :desc_passive
	def initialize (args=[])
		@name = "This is an Instance, self does not have a @name."
		@desc_default = "This is an Instance, self does not have a @desc."
		@desc = @desc_default
		@name_symbol = false
		@name_symbols = []
		@items = []
		@item_descs = {}
		@is_open = true
		@read_files = false
		@to_save = []
		self.initialize_instance (args)
	end
	def initialize_instance (*args)
	end

	def look
		get_text
		if (self.is_item?)
			return "#{@name}\n#{@desc.italic}"  if (self.in_inv?)
			return @desc_passive.italic
		end
		return "#@name\n#{@desc.italic}"          if ($area.to_sym == self.to_sym)
		return @desc_passive.italic               if (self.is_area?)
		return "#@name\n#{@desc_passive.italic}"  if (self.is_person? && self.have_talked)
		return @desc_passive.italic               if (self.is_person?)
		ret = []
		ret.push @name
		ret.push @desc.italic
		@items.each do |item|
			ret.push(@item_descs[item].italic)      if (@is_open && @item_descs[item])
		end
		additional = look_additional
		ret.push additional.italic  if (additional)
		return ret.join("\n")
		#"#{@name}\n#{@desc}".italic
	end
	def look_additional
		false
	end

	def use
		#return false
		return "I can't use #@name.".italic
	end
	def use_with (instance)
		return "I can't use #@name with #{instance.name}.".italic
	end

	def turn
		"#@name can't be turned."
	end
	def turn_on
		"#@name can't be turned on."
	end
	def turn_off
		"#@name can't be turned off."
	end

	def sit
		"I can't sit on #@name."
	end

	def unlock
		"I can't unlock #@name."
	end

	def to_sym (option=false)
		ITEMS.each do |item|
			if (item[1] == self.class)
				@name_symbols = item[0]
				@name_symbol = item[0][0]
				break
			end
		end  unless (@name_symbol && !@name_symbols.empty?) || (!defined?(ITEMS))
		arr = []
		arr.concat AREAS         if defined?(AREAS)
		arr.concat PEOPLE        if defined?(PEOPLE)
		arr.concat AREA_OBJECTS  if defined?(AREA_OBJECTS)
		arr.each do |instance|
			if (instance[1].class == self.class)
				@name_symbols = instance[0]
				@name_symbol = instance[0][0]
			end
		end  unless (@name_symbol && !@name_symbols.empty?)
		@name_symbol = false  unless @name_symbol
		return @name_symbol   unless option == :all
		return @name_symbols  unless !@name_symbols
		return false
	end
	def Instance.to_sym (instance,option=false)
		ITEMS.each do |item|
			if (item[1] == instance.class)
				return item[0][0]  unless option == :all
				return item[0]
			end
		end  unless (@name_symbol && !@name_symbols.empty?)
		Array.new.concat(AREAS,PEOPLE,AREA_OBJECTS).each do |instance|
			if (instance[1] == self)
				return item[0][0]  unless option == :all
				return item[0]
			end
		end  unless (@name_symbol && !@name_symbols.empty?)
		@name_symbol = :no_symbol  unless @name_symbol
		return @name_symbol  unless option == :all
		return @name_symbols
	end

	def get_text
		return  if (@read_files)
		@read_files = true
		eval(File.read("text/#{self.class.superclass.to_s.downcase}/#{self.to_sym}.rb"))  if (File.exists?("text/#{self.class.superclass.to_s.downcase}/#{self.to_sym}.rb"))
	end

	def add_item_instance (item)
		ITEMS.each do |row|
			if (row[0][0] == item) || (row[1] == item)
				@items.push row[0][0]
			end
		end
	end
	def rm_item_instance (item)
		@items.each do |i|
			if (i == item)
				@items.delete i
			end
		end
	end

	def save
		ret = {}
		@to_save.each do |sym|
			ret[sym] = instance_variable_get("@#{sym.to_s}")
		end
		return ret
	end

	def load (data)
		data.each_key do |key|
			instance_variable_set("@#{key.to_s}", data[key])
		end
	end
end

