module Sourcebuster
  class ApplicationController < ActionController::Base
	  layout 'application'

	  include Sourcebuster::CookieSettersHelper
	  before_filter :set_sourcebuster_data
	  helper_method :extract_sourcebuster_data

	  private

		  def set_sourcebuster_data
			  set_sourcebuster_cookies
		  end

  end
end
