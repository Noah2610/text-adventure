
require_relative "./verb"
require_relative "./item"
require_relative "./area"


class Game

	def initialize
		@interaction_state = :normal
	end

	def update
		input = gets.split " "

		case ( @interaction_state )
		when :normal
			process_normal input
			
		when :dialogue

		end
	end

	def process_normal (input)
		verb = false
		item = false
		# person = false

		input.each do |word|

			# check verb
			VERBS.each do |vrow|
				vrow[0].each do |v|
					if (word == v.to_s)
						verb = vrow[1]
						break
					end
				end
			end

			# check item
			ITEMS.each do |irow|
				irow[0].each do |i|
					if (word == i.to_s)
						item = irow[1]
						break
					end
				end
			end


		end

		puts verb.index(item)

	end

end


#@@cur_area = Starting_area.new
game = Game.new
game_running = true

while ( game_running )
	game.update
end

