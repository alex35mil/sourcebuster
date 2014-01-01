require 'test_helper'
require "selenium-webdriver"

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :all

  # Customize it
	TEST_URL = 'http://sandbox.alexfedoseev.com/sourcebuster/showoff'
  YANDEX_TITLE = 'Sandbox'
  GOOGLE_TITLE = 'Alex Fedoseev'
  SEARCH_QUERY = 'sourcebuster busted alex fedoseev'



  # That's ok, we'll take care of the rest

  # yandex and google
  SB_YANDEX = 'yandex'
  SB_GOOGLE = 'google'

  # Traffic types
  SB_UTM = 'utm'
  SB_ORGANIC = 'organic'
  SB_REFERRAL = 'referral'
  SB_TYPEIN = 'typein'

  # Medium types
  SB_REFERER_REFERRAL = 'referral'
  SB_REFERER_ORGANIC = 'organic'
  SB_REFERER_SOCIAL = 'social'
  SB_REFERER_EMAIL = 'email'

  # Aliases for params names in main cookies
  SB_TYPE_ALIAS = 'typ'
  SB_SOURCE_ALIAS = 'src'
  SB_MEDIUM_ALIAS = 'mdm'
  SB_CAMPAIGN_ALIAS = 'cmp'
  SB_CONTENT_ALIAS = 'cnt'
  SB_TERM_ALIAS = 'trm'

  SB_FIRST_DATE = 'fd'
  SB_ENTRANCE_POINT = 'ep'

  SB_USER_IP = 'uip'
  SB_USER_AGENT = 'uag'

  SB_NONE = '(none)'

  # utm params in urls
  UTM_SOURCE_PARAM = 'utm_source='
  UTM_MEDIUM_PARAM = 'utm_medium='
  UTM_CAMPAIGN_PARAM = 'utm_campaign='
  UTM_CONTENT_PARAM = 'utm_content='
  UTM_TERM_PARAM = 'utm_term='

  # Page ids
  FIRST_UTM_TYPE_ID = 'sb_first_typ'
  FIRST_UTM_SOURCE_ID = 'sb_first_src'
  FIRST_UTM_MEDIUM_ID = 'sb_first_mdm'
  FIRST_UTM_CAMPAIGN_ID = 'sb_first_cmp'
  FIRST_UTM_CONTENT_ID = 'sb_first_cnt'
  FIRST_UTM_TERM_ID = 'sb_first_trm'

  CURRENT_UTM_TYPE_ID = 'sb_current_typ'
  CURRENT_UTM_SOURCE_ID = 'sb_current_src'
  CURRENT_UTM_MEDIUM_ID = 'sb_current_mdm'
  CURRENT_UTM_CAMPAIGN_ID = 'sb_current_cmp'
  CURRENT_UTM_CONTENT_ID = 'sb_current_cnt'
  CURRENT_UTM_TERM_ID = 'sb_current_trm'

  # Test utm values
  TEST_UTM_SOURCE_1 = 'yandex'
  TEST_UTM_MEDIUM_1 = 'cpc'
  TEST_UTM_CAMPAIGN_1 = 'y_campaign'
  TEST_UTM_CONTENT_1 = 'y_banner'
  TEST_UTM_TERM_1 = 'y_key'

  TEST_UTM_SOURCE_2 = 'google'
  TEST_UTM_MEDIUM_2 = 'cpc'
  TEST_UTM_CAMPAIGN_2 = 'g_campaign'
  TEST_UTM_CONTENT_2 = 'g_banner'
  TEST_UTM_TERM_2 = 'g_key'


  def setup
	  @browser = Selenium::WebDriver.for :firefox
  end

  def teardown
	  @browser.quit
  end

  def visit_with_utms(utm_source, utm_medium, utm_campaign, utm_content, utm_term)
	  @browser.navigate.to TEST_URL + '?' +
	                       UTM_SOURCE_PARAM + utm_source + '&' +
	                       UTM_MEDIUM_PARAM + utm_medium + '&' +
	                       UTM_CAMPAIGN_PARAM + utm_campaign + '&' +
	                       UTM_CONTENT_PARAM + utm_content + '&' +
	                       UTM_TERM_PARAM + utm_term
  end

  def visit_from_yandex
	  @browser.navigate.to 'http://www.yandex.ru'
	  @browser.find_element(:name, 'text').send_keys(SEARCH_QUERY)
	  @browser.find_element(:name, 'text').submit
	  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	  wait.until { @browser.find_element(:partial_link_text, YANDEX_TITLE).click }
  end

  def visit_from_google
	  @browser.navigate.to 'http://www.google.com'
	  @browser.find_element(:name, 'q').send_keys(SEARCH_QUERY)
	  @browser.find_element(:name, 'q').submit
	  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	  wait.until { @browser.find_element(:partial_link_text, GOOGLE_TITLE).click }
  end

  def check_utm_elements (cookie, utm_type, utm_source, utm_medium, utm_campaign, utm_content, utm_term)

	  if cookie == :first

		  element_first_type = @browser.find_element(:id, FIRST_UTM_TYPE_ID)
		  assert element_first_type.text.include? utm_type

		  element_first_source = @browser.find_element(:id, FIRST_UTM_SOURCE_ID)
		  assert element_first_source.text.include? utm_source

		  element_first_medium = @browser.find_element(:id, FIRST_UTM_MEDIUM_ID)
		  assert element_first_medium.text.include? utm_medium

		  element_first_campaign = @browser.find_element(:id, FIRST_UTM_CAMPAIGN_ID)
		  assert element_first_campaign.text.include? utm_campaign

		  element_first_content = @browser.find_element(:id, FIRST_UTM_CONTENT_ID)
		  assert element_first_content.text.include? utm_content

		  element_first_term = @browser.find_element(:id, FIRST_UTM_TERM_ID)
		  assert element_first_term.text.include? utm_term

	  elsif cookie == :current

		  element_current_type = @browser.find_element(:id, CURRENT_UTM_TYPE_ID)
		  assert element_current_type.text.include? utm_type

		  element_current_source = @browser.find_element(:id, CURRENT_UTM_SOURCE_ID)
		  assert element_current_source.text.include? utm_source

		  element_current_medium = @browser.find_element(:id, CURRENT_UTM_MEDIUM_ID)
		  assert element_current_medium.text.include? utm_medium

		  element_current_campaign = @browser.find_element(:id, CURRENT_UTM_CAMPAIGN_ID)
		  assert element_current_campaign.text.include? utm_campaign

		  element_current_content = @browser.find_element(:id, CURRENT_UTM_CONTENT_ID)
		  assert element_current_content.text.include? utm_content

		  element_current_term = @browser.find_element(:id, CURRENT_UTM_TERM_ID)
		  assert element_current_term.text.include? utm_term

	  end

  end


  test "utms are correct, utm -> utm override is correct, utm -> yandex organic override is correct" do

	  # test utm
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)


	  # test utm -> utm override
	  visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)


	  # test utm -> yandex organic override
	  visit_from_yandex
	  @browser.switch_to.window(@browser.window_handles.last)
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

	test "utm -> google organic override is correct" do

		# test first visit with utms
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> google organic override
		visit_from_google
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	end

end

