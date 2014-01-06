module Sourcebuster
  class RefererSource < ActiveRecord::Base

		belongs_to :referer_type, :class_name => 'Sourcebuster::RefererType'

		before_save { self.domain = domain.gsub(/(http:|https:|www\.|:|\/)/,'').downcase }
		before_save { self.organic_query_param = organic_query_param.gsub('=', '').downcase if self.organic_query_param }

		validates :domain, presence: true,
		          uniqueness: { case_sensitive: false }
		validates :referer_type_id, presence: true
		validates_presence_of :organic_query_param, if: :referer_type_organic?

		def referer_type_organic?
			referer_type_id == Sourcebuster::RefererType.select('id').where(referer_type: 'organic').first
		end

  end
end
