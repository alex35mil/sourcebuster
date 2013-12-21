module Sourcebuster
  class RefererType < ActiveRecord::Base

	  has_many :referer_sources, :class_name => 'Sourcebuster::RefererSource', foreign_key: "referer_type_id"
		validates :referer_type, presence: true,
              uniqueness: { case_sensitive: false }

  end
end
