
class Test_verb < Verb
	def init
	end
	def action (*args)
		return $area.items.join("\n").to_s
	end
end

class Save < Verb
	def init
	end
	def action (*args)
		save_game
	end
end

class Load < Verb
	def init
	end
	def action (*args)
		load_game
	end
end

