class LandingsController < ApplicationController

	def index
	end

	def twc
		# simply redering index with twc
		render :index
	end

	def cox
		# simply redering index with cox
		render :index
	end

	def charter_spectrum
		# simply redering index with charter_spectrum
		render :index
	end
end
