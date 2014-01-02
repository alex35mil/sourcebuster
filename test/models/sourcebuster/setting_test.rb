require 'test_helper'

module Sourcebuster
  class SettingTest < ActiveSupport::TestCase

	  test "main host should not be empty if use_subdomains set to true" do
		  s = Sourcebuster::Setting.new(use_subdomains: true)
		  s.valid?
		  assert s.errors[:main_host].any?
	  end

	  test "main host should have at least one dot in the middle" do
		  host = 'goog-leee'
		  s = Sourcebuster::Setting.new(use_subdomains: true,
		                                main_host: host)
		  s.valid?
		  assert s.errors[:main_host].any?
	  end

	  test "main host should not have www and http stuff" do
		  main_host_1 = 'http://www.Google-ht.com'
		  s_1 = Sourcebuster::Setting.new(use_subdomains: true,
		                                  main_host: main_host_1)
		  main_host_2 = 'https://www.http-Domain.com'
		  s_2 = Sourcebuster::Setting.new(use_subdomains: true,
		                                  main_host: main_host_2)
		  assert s_1.save
		  assert s_1[:main_host] == 'google-ht.com'
		  assert s_2.save
		  assert s_2[:main_host] == 'http-domain.com'
	  end


  end
end
