
class Joint_item < Item
	def init
		@name = "Joint".blue
	end
end

# keychain for cell_abduct
class Keychain_cell_abduct_item < Item
	def init
	end
	def use
		if ($area.to_sym == :cell_abduct)
			return find_areaObject(:cell_door_abduct).unlock
		end
	end
end

# stick (pipe or bone or something) to get keychain with
class Stick_abduct_item < Item
	def init
	end
	def use_with (instance)
		if (instance.to_sym == :guard_abduct)
			return instance.get_keychain
			# NOTE remove keychain?
		else
			return "I can't use #@name with #{instance.name}."
		end
	end
end

