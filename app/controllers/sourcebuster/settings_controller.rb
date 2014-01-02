require_dependency "sourcebuster/application_controller"

module Sourcebuster
  class SettingsController < ApplicationController

		def index
			@settings = Sourcebuster::Setting.first
		end

		def edit
			@settings = Sourcebuster::Setting.first
		end

		def update
			@settings = Sourcebuster::Setting.first
			if @settings.update_attributes(settings_params)
				flash[:success] = "Woohoo! Settings updated!"
				redirect_to sourcebuster.settings_url
			else
				render :edit
			end
		end

		private

		def settings_params
			params.require(:setting).permit(:session_length, :use_subdomains, :main_host)
		end

  end
end
