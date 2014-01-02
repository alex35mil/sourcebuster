require_dependency "sourcebuster/application_controller"

module Sourcebuster
  class RefererSourcesController < ApplicationController

		def index
			@referer_sources = Sourcebuster::RefererSource.all
		end

		def edit
			@referer_source = Sourcebuster::RefererSource.find(params[:id])
		end

		def update
			@referer_source = Sourcebuster::RefererSource.find(params[:id])
			if @referer_source.update_attributes(referer_source_params)
				flash[:success] = "Woohoo! Custom Source updated!"
				redirect_to sourcebuster.referer_sources_url
			else
				render :edit
			end
		end

		def new
			@referer_source = Sourcebuster::RefererSource.new
		end

		def create
			@referer_source = Sourcebuster::RefererSource.new(referer_source_params)
			if @referer_source.save
				flash[:success] = "Woohoo! Custom Source created!"
				redirect_to sourcebuster.referer_sources_url
			else
				render :new
			end
		end

		def destroy
			Sourcebuster::RefererSource.find(params[:id]).destroy
			flash[:success] = "Custom Source deleted. Happy now, eh?"
			redirect_to sourcebuster.referer_sources_url
		end

		private

		def referer_source_params
			params.require(:referer_source).permit(:domain,
			                                       :source_alias,
			                                       :referer_type_id,
			                                       :organic_query_param)
		end

  end
end
