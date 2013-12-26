require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :all

	TEST_HOST = 'http://sandbox.alexfedoseev.com'
  TEST_PATH = '/sourcebuster/showoff'

  UTM_SOURCE_PARAM = 'utm_source='
  UTM_MEDIUM_PARAM = 'utm_medium='
  UTM_CAMPAIGN_PARAM = 'utm_campaign='
  UTM_CONTENT_PARAM = 'utm_content='
  UTM_TERM_PARAM = 'utm_term='



  test "utm are correct" do

	  utm_source = 'yandex'
	  utm_medium = 'cpc'
	  utm_campaign = 'y_campaign'
	  utm_content = 'banner_1'
	  utm_term = 'key'

	  host! TEST_HOST
	  get TEST_PATH + '?' +
			  UTM_SOURCE_PARAM + utm_source +
			  UTM_MEDIUM_PARAM + utm_medium +
	      UTM_CAMPAIGN_PARAM + utm_campaign +
	      UTM_CONTENT_PARAM + utm_content +
	      UTM_TERM_PARAM + utm_term

	  assert_response :success

  end

end

