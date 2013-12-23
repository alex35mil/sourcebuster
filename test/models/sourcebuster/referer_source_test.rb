require 'test_helper'

module Sourcebuster
  class RefererSourceTest < ActiveSupport::TestCase

	  test "referer source domain and referer_type should not be empty" do
		  r_s = Sourcebuster::RefererSource.new
		  assert r_s.invalid?
		  assert r_s.errors[:domain].any?
		  assert r_s.errors[:referer_type_id].any?
	  end

	  test "referer source domain should be unique" do
		  r_s_domain = 'Google.com'
		  r_s_1 = Sourcebuster::RefererSource.new(domain: r_s_domain,
		                                          referer_type_id: 1)
		  r_s_2 = Sourcebuster::RefererSource.new(domain: r_s_domain.downcase,
		                                          referer_type_id: 2)
		  assert r_s_1.save
		  r_s_2.valid?
		  assert r_s_2.errors[:domain].any?
	  end

	  test "referer source domain should not have www" do
		  r_s_domain = 'www.Google.com'
		  r_s = Sourcebuster::RefererSource.new(domain: r_s_domain,
		                                        referer_type_id: 1)
		  assert r_s.save
		  assert r_s[:domain] == r_s_domain.gsub('www.', '').downcase
		  assert r_s[:domain] == 'google.com'
	  end

	  test "referer source organic_query_param should not be empty if referer_type is organic" do
		  r_s_type_id = Sourcebuster::RefererType.find_by(referer_type: 'organic')
		  r_s = Sourcebuster::RefererSource.new(domain: 'google.com',
		                                        referer_type_id: r_s_type_id)
		  r_s.valid?
		  assert r_s.errors[:organic_query_param].any?
	  end

  end
end
