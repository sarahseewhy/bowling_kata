require_relative '../lib/bowling'

describe BowlingGame do 

	let (:game) {BowlingGame.new}

	it 'can instantiate a new Game with an empty scoreboard' do
		expect(game).to be_a BowlingGame
	end

	it 'can roll a gutter game' do
		20.times{game.roll(0)}
		expect(game.total_score).to eq(0)
	end	

	it 'can roll a normal point scoring game' do
		20.times{game.roll(1)}
		expect(game.total_score).to eq(20)
	end

	it 'can roll a spare' do
		game.roll(5)
		game.roll(5)
		game.roll(5)
		17.times{game.roll(0)}
		expect(game.total_score).to eq(15)
	end

	it 'can roll a strike' do
		game.roll(10)
		game.roll(3)
		game.roll(6)
		16.times{game.roll(0)}
		expect(game.total_score).to eq(28)
	end

	it 'can add all elements in scoreboard to get total score' do
		game.roll(3)
		game.roll(5)
		game.roll(1)
		17.times{game.roll(0)}
		expect(game.total_score).to eq(9)
	end

end







