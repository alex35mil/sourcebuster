module Sourcebuster
  class RefererSource < ActiveRecord::Base

		belongs_to :referer_type, :class_name => 'Sourcebuster::RefererType'

		before_save { self.domain = domain.gsub('www.', '').downcase }

		validates :domain, presence: true,
		          uniqueness: { case_sensitive: false }
		validates :referer_type_id, presence: true
		validates_presence_of :organic_query_param, :if => lambda { self.referer_type_id == get_organic_type_id }

		def get_organic_type_id
			Sourcebuster::RefererType.find_by(referer_type: 'organic')
		end

  end
end
