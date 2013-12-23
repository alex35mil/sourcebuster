require 'test_helper'

module Sourcebuster
  class RefererTypeTest < ActiveSupport::TestCase

    test "referer type should not be empty" do
      r_t = Sourcebuster::RefererType.new
	    assert r_t.invalid?
	    assert r_t.errors[:referer_type].any?
    end

    test "referer type should be unique" do
	    r_t_name = 'Referral'
      r_t_1 = Sourcebuster::RefererType.new(referer_type: r_t_name)
      r_t_2 = Sourcebuster::RefererType.new(referer_type: r_t_name.downcase)
	    assert r_t_1.save
	    r_t_2.valid?
	    assert r_t_2.errors[:referer_type].any?
    end

  end
end
