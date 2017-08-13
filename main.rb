
require "colorize"


class Instance
	def initialize
		@desc = "This is an Instance, self does not have a @desc."
	end
	def look
		@desc
	end
end

# require area first (for global area vars below)
require_relative "./area"

$area = AREAS[0][0][0]
AREAS.each do |area|
	if ($area == area[0][0])
		$area_ref = area[1]
	end
end
$area_neighbors = AREA_MAP[$area]

# require other classes
require_relative "./verb"
require_relative "./item"


class Game

	def initialize
		puts "TESTING"
		@interaction_state = :normal
		$inventory = []
		add_item :inventory
		add_item :test_item
	end

	def update
		puts "---\nCurrent Area: " + $area.to_s

		print "> "
		input = gets.split " "

		case ( @interaction_state )
		when :normal
			process_normal input
			
		when :dialogue

		end
	end

	def accept_input? (keyword,input)
		(keyword.to_s.index(input) == 0) && (input.length > 2 || input.length == keyword.length)
	end

	def process_normal (input)
		opts = {}
		input_verb = false
		input_item = false
		input_area = false
		input_area_sym = false
		# person = false

		input.each do |word|

			# check verb
			VERBS.each do |vrow|
				vrow[0].each do |v|
					if (word == v.to_s)
						input_verb = vrow[1]
						break
					end
				end
			end

			# check items
			$inventory.each do |irow|
				irow[0].each do |i|
					if (accept_input?(i,word))
						input_item = irow[1]
						break
					end
				end
			end

			# check area
			catch (:big_break) do
				Array.new.concat($area_neighbors,[$area]).each do |area|
					AREAS.each do |arow|
						if (area == arow[0][0])
							arow[0].each do |a|
								if (accept_input?(a,word))
									input_area = arow[1]
									opts[:area_sym] = arow[0][0]
									throw :big_break
								end
							end
						end
					end
				end
			end

			#AREAS.each do |arow|
				#arow[0].each do |a|
					#if (accept_input?(a,word))
						#input_area = arow[1]
						#break
					#end
				#end
			#end

		end

		if (input_verb && input_area)
			# use with area
			puts input_verb.action(input_area,opts)
		elsif (input_verb && input_item)
			# use with item
			puts input_verb.action(input_item)
		elsif (input_verb)
			# use without item
			puts input_verb.action
		end

	end

end


game = Game.new
game_running = true

while ( game_running )
	game.update
end

