
require "colorize"
require "awesome_print"


class Instance
	def initialize (*args)
		@name = "This is an Instance, self does not have a @name."
		@desc = "This is an Instance, self does not have a @desc."
		@name_symbol = false
		@name_symbols = []
		@items = []
		self.initialize_instance (args)
	end
	def look
		"#{@name}\n#{@desc}"
	end
	def to_sym (option=false)
		ITEMS.each do |item|
			if (item[1].new.class == self.class)
				@name_symbols = item[0]
				@name_symbol = item[0][0]
				break
			end
		end  unless (@name_symbol && !@name_symbols.empty?)
		Array.new.concat(AREAS,PEOPLE).each do |instance|
			if (instance[1] == self)
				@name_symbols = instance[0]
				@name_symbol = instance[0][0]
			end
		end  unless (@name_symbol && !@name_symbols.empty?)
		@name_symbol = :no_symbol  unless @name_symbol
		return @name_symbol  unless option == :all
		return @name_symbols
	end
	def Instance.to_sym (instance,option=false)
		ITEMS.each do |item|
			if (item[1].new.class == instance.class)
				return item[0][0]  unless option == :all
				return item[0]
			end
		end  unless (@name_symbol && !@name_symbols.empty?)
		Array.new.concat(AREAS,PEOPLE).each do |instance|
			if (instance[1] == self)
				return item[0][0]  unless option == :all
				return item[0]
			end
		end  unless (@name_symbol && !@name_symbols.empty?)
		@name_symbol = :no_symbol  unless @name_symbol
		return @name_symbol  unless option == :all
		return @name_symbols
	end

	def add_item (item)
		ITEMS.each do |row|
			if (row[0][0] == item) || (row[1] == item)
				@items.push row[0][0]
			end
		end
	end
	def rm_item (item)
		@items.each do |i|
			if (i == item)
				@items.delete i
			end
		end
	end
end

# require area first (for global area vars below)
require_relative "./area"
require_relative "./item"
require_relative "./verb"
require_relative "./keyword"
require_relative "./person"

$area = AREAS[0][1]
$area.has_visited = true


def add_item (item)
	ITEMS.each do |row|
		if (row[0][0] == item)
			$inventory.push [row[0],row[1].new(row[2])]
			return true
		end
	end
	throw "Couldn't add_item: #{item} (#{item.class})"
end

def remove_item (item)
	$inventory.each_with_index do |row,i|
		if (row[0][0] == item)
			$inventory.delete_at i
			return true
		end
	end
	return false
	throw "Couldn't rm_item: #{item} (#{item.class})"
end

def get_input
	return gets.downcase.delete("'.,!?-").split(" ")
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
		puts "Current Area: #{$area.name} (#{$area.to_sym.to_s})"

		print ">"  if $interaction_state == :talk
		print "> "
		input = get_input

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
		$area.items.each do |aitems|
			ITEMS.each do |row|
				if (row[0][0] == aitems)
					row[0].each do |item|
						if (accept_input?(item,word))
							return row[1].new
						end
					end
				end
			end
		end
		return false
	end

	def input_check_area (word)
		Array.new.concat($area.neighbors,$area.to_sym(:all)).each do |area|
			AREAS.each do |arow|
				if (area == arow[0][0])
					arow[0].each do |a|
						if (accept_input?(a,word))
							return arow[1]
						end
					end
				end
			end
		end
		return false
	end

	def input_check_person (word)
		$area.people.each do |person|
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

	def input_include? (input,instance)
		instance.each do |row|
			row[0].each do |area|
				if (input.include? area.to_s.gsub("_"," "))
					return row[1]  unless row[1].class == Class
					return row[1].new
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
		#input_item     = false
		#input_item2    = false
		#input_area     = false
		#input_area_sym = false
		#input_person   = false
		params = {items:[],areas:[],people:[]}

		# check for include s
			# check items
			input_item = input_include?(input, Array.new.concat($inventory,$area.items))
			params[:items].push input_item     if input_item
			# check areas
			input_area = input_include?(input, AREAS)
			params[:areas].push input_area     if input_area
			# check person
			input_person = input_include?(input, PEOPLE)
			params[:people].push input_person  if input_person

		input.each do |word|

			# check verb
			input_verb = input_check_verb word  unless input_verb

			# check items
			input_item = input_check_item word
			params[:items].push input_item     if input_item
			# IMPORTANT:
			# implement some mechanic to read and properly process 2 (or maybe more) items!

			# check area(s)
			input_area = input_check_area word
			params[:areas].push input_area     if input_area

			# check person
			input_person = input_check_person word
			params[:people].push input_person  if input_person

			#AREAS.each do |arow|
			#arow[0].each do |a|
			#if (accept_input?(a,word))
			#input_area = arow[1]
			#break
			#end
			#end
			#end

		end

		params[:items].uniq!
		params[:areas].uniq!
		params[:people].uniq!

		puts input_verb.action(params)  if input_verb

		if (!params[:items].empty? || !params[:areas].empty? || !params[:people].empty?) && (!input_verb)
			# look at Person if only person is given
			puts Look.new.action(params)
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

