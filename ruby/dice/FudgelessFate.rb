#!/usr/bin/env ruby

class Fate

	DIFFICULTY_LADDER = %{
	6 Nearly Impossible
	5 Staggering
	4 Daunting
	3 Difficult
	2 Mundane
	1 Simple
	0 Trivial
	}.map{|line| n,a=line.split; n || next; [n.to_i,a] }.compact

	SKILL_LADDER = %{
	8 Amazing
	7 Excellent
	6 Great
	5 Good
	4 Fair
	3 Mediocre
	2 Poor
	1 Bad
	0 Abysmal
	}.map{|line| n,a=line.split; n || next; [n.to_i,a] }.compact

	def self.roll(skill, difficulty)
		srand
		result = 0
		skill.times { result += rand(2) }
		result - difficulty
	end

	def self.prob(skill, difficulty)
		n = skill
		p = 0.5
		result = 0.0
		(difficulty..skill).each do |x|
			prob_n_successes = combinations(n, x)*(p ** x)*(p ** (n - x))
			result += prob_n_successes
		end
		result
	end

	private

	def self.combinations(n, k)
		factorial(n).to_f / (factorial(k) * factorial(n - k))
	end

	def self.factorial(n)
		n <= 0 ? 1 : (n * factorial(n - 1))
	end
end

(1..10).each do |skill|
	(1..10).each do |difficulty|
#		puts format("Skill %2d vs. difficulty %2d = %f", skill, difficulty, Fate.prob(skill, difficulty))
		print format("%f\t", Fate.prob(skill, difficulty))
	end
	puts ''
end
