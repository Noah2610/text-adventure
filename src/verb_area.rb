

class WakeUp < Verb
	def init
	end
	def action (items:[],areas:[],people:[],areaObjects:[],misc:{})
		arr = Array.new.concat(items,areas,people,areaObjects)
		return "Wake up what?"  if arr.empty?
		ret = []
		arr.each do |instance|
			if (instance.methods.include?(:wake_up))
				ret.push instance.wake_up
			else
				ret.push "I can't wake up #{instance.name}."
			end
		end
		return ret.join("\n")
	end
end


VERBS_AREA = [
	# [[ AREAS ], [ KEYWORDS ],
	#  VERB ]
	[[:corridor_abduct,:other_cell_abduct], [:wake_up,:wake,:awake],
		WakeUp.new ]
]

