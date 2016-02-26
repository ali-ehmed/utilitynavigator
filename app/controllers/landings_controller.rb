class LandingsController < ApplicationController

	def index
	end

	def providers
		
	end

	def twc
		@provider_banner = "twc.png"
		# simply redering providers with twc
		render :providers
	end

	def cox
		# simply redering providers with cox
		@provider_banner = "cox.png"
		render :providers
	end

	def charter_spectrum
		# simply redering providers with charter_spectrum
		@provider_banner = "charter.png"
		render :providers
	end
end
