
class Test_item < Item
	def init
		@name = "Test Item".red
		@desc = "This is a #{@name}.\nIt looks as if it's sole purpose is functionality testing."
	end
end

class Foo < Item
	def init
		@name = "Foo".yellow
		@desc = "FOoobar barfoo"
		@desc_passive = "fooo's passive description"
	end
end

class Bar < Item
	def init
		@name = "Bar".blue
		@desc = "Hello".green + " World".yellow
		@desc_passive = "Bar passive yo yo yo"
	end
end

class Apple < Item
	def init
		@name = "Apple".red
		@desc = "It's really moldy and rotten.\nWho knows how long it's been in that box already."
	end
end

