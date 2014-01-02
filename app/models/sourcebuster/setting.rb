module Sourcebuster
  class Setting < ActiveRecord::Base

	  before_save { self.main_host = main_host.gsub(/(http:|https:|www\.|:|\/)/,'').downcase if self.main_host }

	  # check at least one dot in the middle
	  VALID_HOST_REGEX = /\A.+\..+\z/i
	  validates_presence_of :main_host, :if => lambda { self.use_subdomains }
		validates :main_host, format: { with: VALID_HOST_REGEX }

  end
end
