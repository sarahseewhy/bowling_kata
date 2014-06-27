class BowlingGame

	def initialize
		@scoreboard = []
	end

	def roll(points)
		@scoreboard << (points)
		@scoreboard
	end

	def strike?(index)
		@scoreboard[index] == 10
	end

	def scoring_strike(index)
		@scoreboard[index] + @scoreboard[index + 1] + @scoreboard[index + 2]
	end

	def spare?(index)
		@scoreboard[index] + @scoreboard[index + 1] == 10
	end

	def scoring_spare(index)
		@scoreboard[index] + @scoreboard[index + 1] + @scoreboard[index + 3]
	end

	def scoring(index)
		@scoreboard[index] + @scoreboard[index + 1]
	end

	def total_score
		result = 0
		index = 0
		10.times do
			if strike?(index)
				result += scoring_strike(index)
				index += 1
			elsif spare?(index)
				result += scoring_spare(index)
				index += 2
			else
				result += scoring(index)
				index += 2
			end
		end
		result	
	end

end
