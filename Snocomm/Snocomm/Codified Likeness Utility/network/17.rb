class Github
	def initialize(apple)
		@company = apple
	end


	def boot
		puts "https://www.github.com" + @company
	end
end

hi = Github.new("/apple")
hi.boot