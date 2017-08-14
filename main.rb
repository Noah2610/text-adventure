
require "colorize"


class Instance
	def initialize
		@name = "This is an Instance, self does not have a @name."
		@desc = "This is an Instance, self does not have a @desc."
		@name_symbol = false
	end
	def look
		"#{@name}\n#{@desc}"
	end
	def to_sym
		ITEMS.each do |item|
			if (item[1].new.class == self.class)
				@name_symbol = item[0][0]
				break
			end
		end  unless @name_symbol
		Array.new.concat(AREAS,PEOPLE).each do |instance|
			if (instance[1] == self)
				@name_symbol = instance[0][0]
			end
		end  unless @name_symbol
		@name_symbol = :no_symbol  unless @name_symbol
		return @name_symbol
	end
end

# require area first (for global area vars below)
require_relative "./area"
require_relative "./item"

$area = AREAS[0][0][0]
AREAS.each do |area|
	if ($area == area[0][0])
		$area_ref = area[1]
	end
end
$area_neighbors = AREA_MAP[$area]

# require other classes
require_relative "./verb"
require_relative "./keyword"
require_relative "./person"


def add_item(item)
	ITEMS.each do |row|
		if (row[0][0] == item) || (row[1] == item)
			$inventory.push [row[0],row[1].new(row[2])]
		end
	end
end

def rm_item (item)
	$inventory.each_with_index do |row,i|
		if (row[0][0] == item) || (row[1] == item)
			$inventory.delete_at i
		end
	end
end

def has_item? (item)
	$inventory.each do |row|
		if (row[0][0] == item) || (row[1] == item)
			return true
		end
	end
	return false
end


class Game

	def initialize
		$interaction_state = :normal
		$talking_to = false
		$inventory = []
		add_item :inventory
		add_item :test_item
	end

	def update
		puts "Current Area: " + $area.to_s

		print ">"  if $interaction_state == :talk
		print "> "
		input = gets.downcase.delete("'.,!?-").split(" ")

		case ( $interaction_state )
		when :normal
			process_normal input

		when :talk
			process_talk input
		end
	end

	def accept_input? (keyword,input)
		(keyword.to_s.index(input) == 0) && (input.length > 2 || input.length == keyword.length)
	end

	def input_check_verb (word)
		VERBS.each do |vrow|
			vrow[0].each do |v|
				if (word == v.to_s)
					return vrow[1]
				end
			end
		end
		return false
	end

	def input_check_item (word)
		$inventory.each do |irow|
			irow[0].each do |i|
				if (accept_input?(i,word))
					return irow[1]
				end
			end
		end
		$area_ref.items.each do |aitems|
			ITEMS.each do |row|
				if (row[0][0] == aitems)
					row[0].each do |item|
						if (accept_input?(item,word))
							return row[1]
						end
					end
				end
			end
		end
		return false
	end

	def input_check_area (word)
		Array.new.concat($area_neighbors,[$area]).each do |area|
			AREAS.each do |arow|
				if (area == arow[0][0])
					arow[0].each do |a|
						if (accept_input?(a,word))
							return [arow[1],{area_sym:arow[0][0]}]
						end
					end
				end
			end
		end
		return false
	end

	def input_check_person (word)
		$area_ref.people.each do |person|
			PEOPLE.each do |prow|
				if (person == prow[0][0])
					prow[0].each do |p|
						if (accept_input?(p,word))
							return prow[1]
						end
					end
				end
			end
		end
		return false
	end

=begin  catch-throw (to break out of multiple nested loops)
	catch (:some_symbol) do
		...
		throw :some_symbol
		...
	end
=end

	def process_normal (input)
		input_verb     = false
		input_item     = false
		input_item2    = false
		input_area     = false
		input_area_sym = false
		input_person   = false
		# person = false

		input.each do |word|

			# check verb
			input_verb = input_check_verb word      unless input_verb

			# check items
			input_item = input_check_item word      unless input_item
			# IMPORTANT:
			# implement some mechanic to read and properly process 2 (or maybe more) items!

			# check area
			input_area = input_check_area word      unless input_area
			if (input_area.class == Array)
				input_area_sym = input_area[1]
				input_area = input_area[0]
			end

			# check person
			input_person = input_check_person word  unless input_person

			#AREAS.each do |arow|
			#arow[0].each do |a|
			#if (accept_input?(a,word))
			#input_area = arow[1]
			#break
			#end
			#end
			#end

		end

		if (input_verb && input_item && input_person)
			# use Item with Person
			puts input_verb.action(input_person,item:input_item)

		elsif (input_verb && input_person)
			# use with Person
			puts input_verb.action(input_person)

		elsif (input_verb && input_area)
			# use with Area
			puts input_verb.action(input_area,input_area_sym)

		elsif (input_verb && input_item)
			# use with Item
			puts input_verb.action(input_item)

		elsif (input_verb)
			# use without Item
			puts input_verb.action

		elsif (input_person)
			# look at Person if only person is given
			puts Look.action(input_person)
		end

	end


	def process_talk (input)
		params = {items:[],areas:[],people:[]}
		method = false

		KEYWORDS_TALK_PHRASES.each do |phrases|
			phrases[0].each do |phrase|
				if (input.join(" ").include? phrase)
					method = phrases[1]
				end
			end
		end

		input.each do |word|

			# check method
			catch (:big_break) do
				KEYWORDS_TALK.each do |row|
					row.each do |kw|
						if (kw.to_s == word)
							method = row[0]
							throw :big_break
						end
					end
				end
			end

			input_item   = input_check_item word
			params[:items].push input_item          if input_item
			input_area   = input_check_area word
			params[:areas].push input_area          if input_item
			input_person = input_check_person word
			params[:people].push input_person       if input_item

		end  unless method

		puts $talking_to.method("talk_" + method.to_s).call(params)  if method

	end
end


game = Game.new
game_running = true

while ( game_running )
	game.update
end

