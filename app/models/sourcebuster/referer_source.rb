module Sourcebuster
  class RefererSource < ActiveRecord::Base

		belongs_to :referer_type, :class_name => 'Sourcebuster::RefererType'

		validates :domain, presence: true
		validates :referer_type_id, presence: true
		validates_presence_of :organic_query_param, :if => :is_organic?

		def is_organic?
			referer_type == 'organic'
		end

  end
end
