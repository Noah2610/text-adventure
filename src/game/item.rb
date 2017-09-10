
class Joint_item < Item
	def init
		@name = "Joint".blue
	end
end

# keychain for cell_abduct
class Keychain_cell_abduct_item < Item
	def init
	end
end

# stick (pipe or bone or something) to get keychain with
class Stick_abduct_item < Item
	def init
	end
	def use_with (instance)
		if (instance.to_sym == :guard_abduct)
			return instance.get_keychain
		else
			return "I can't use #@name with #{instance.name}."
		end
	end
end

