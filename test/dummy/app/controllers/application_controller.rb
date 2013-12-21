class ApplicationController < ActionController::Base

	include Sourcebuster::CookieSettersHelper
	before_filter :set_sourcebuster_data
	helper_method :extract_sourcebuster_data

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	private

		def set_sourcebuster_data
			set_sourcebuster_cookies
		end

end
