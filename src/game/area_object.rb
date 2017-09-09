
class Glove_compartment_areaObject < Area_object
	def init (args=[])
		@items = [:joint]
		@is_open = false
		@to_save.push :is_open
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

class Console_abduct_areaObject < Area_object
	def init (args=[])
		@turned_on = false
		@cmd_not_found = gibberish
		@to_save.push :turned_on
	end
	def use
		return @text[:use_turned_off]  unless (@turned_on)
		ret = []
		#ret.push "§ " + gibberish
		#ret.push @text[:use].italic
		print " § ".bold
		continue_input = true
		user_cmd = []
		while (continue_input)
			STDIN.noecho do |a|
				char = STDIN.getch
				if (char == "\r" || char == "\n")
					print("\n   " + user_cmd.join("") + ": " + @cmd_not_found.red)
					continue_input = false
				else
					user_cmd.push gibberish_char
					print user_cmd.last
				end
			end
		end
		return ret.join("\n")
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

	def gibberish
		arr = ("!"..."0").to_a.concat((":"..."A").to_a).concat(("["..."a").to_a).shuffle[0..rand(10..40)]
		skip = false
		arr.map! do |a|
			if (!skip) && (rand(0...5) == 0)
				skip = true
				next " "
			else
				skip = false
				skip = true  if (a == " ")
				next a
			end
		end
		return arr.join("")
	end
	def gibberish_char
		return (" "..."0").to_a.concat((":"..."A").to_a).concat(("["..."a").to_a).sample
	end

end

class Sofa_abduct_areaObject < Area_object
	def init
	end

	def sit
		"I sit down on the #@name for a while but then I stand up again.".italic
	end
end


# spaceship cell bed
class CellBed_abduct_areaObject < Area_object
	def init
		@have_slept = false
		@to_save.push :have_slept
	end
	def use
		# sleep in bed
		if (true)  # if player can go to sleep already
			@have_slept = true
			return "i sleep in bed now"
		else
			return ["I don't think I'm ready to sleep yet.", "I don't feel tired.", "I don't want to sleep yet."].sample
		end
	end
end

# cell wall
class CellWall_abduct_areaObject < Area_object
	def init
		@is_open = false
		@items = [:stick_abduct]
		#@item_descs = { stick_abduct: @text[:stick_desc]}
		@to_save.push :is_open, :items
	end

	def open
		unless (@is_open)
			@is_open = true
			@item_descs = { stick_abduct: "There's a stick-like thing inside.\nIt looks long thin and grabbable."}  if @item_descs.empty?
			return @text[:wall_open]
		else
			return "There's already a big hole in the wall."
		end
	end
	def close
		if (@is_open)
			@is_open = false
			return "I put the loose tile back into to wall."
		else
			return "It's not open."
		end
	end
	def use
		open
	end

	def look_additional
		return @text[:open_desc]	  if @is_open
		return @text[:closed_desc]  if !@is_open
	end
end

