
class Test_verb < Verb
	def init
	end
	def action (*args)
		return $area.items.join("\n").to_s
	end
end

