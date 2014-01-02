require 'test_helper'
require 'selenium-webdriver'

class NavigationTest < ActionDispatch::IntegrationTest
  fixtures :all

  ### Customize it

  # Set test browser (:chrome, :firefox, :safari, :ie / :internet_explorer, :opera)
  TEST_BROWSER = :firefox

  # Set url of your test page
  TEST_URL = 'http://sandbox.alexfedoseev.com/sourcebuster/showoff'

  # Set title of your test page in Yandex SERP
  YANDEX_TITLE = 'Sandbox'

  # Set title of your test page in Google SERP
  GOOGLE_TITLE = 'Alex Fedoseev'

  # Set search query that will help Selenium find the link to your test page in SERPs
  SEARCH_QUERY = 'sourcebuster busted alex fedoseev'

  # Set custom search engine
  ORGANIC_CUSTOM_ENGINE = 'rambler.ru'

  # Set params of your custom referral page
  TEST_REFERRAL_CUSTOM_URL = 'https://twitter.com/alexfedoseev/status/414727930774683650'
  TEST_REFERRAL_CUSTOM_LINK_TEXT = 'http://sandbox.alexfedoseev.com/'
  TEST_REFERRAL_CUSTOM_SOURCE = 'twitter'
  TEST_REFERRAL_CUSTOM_MEDIUM = 'social'

  # Set params of your common referral page
  TEST_REFERRAL_URL = 'http://alexfedoseev.livejournal.com/86172.html'
  TEST_REFERRAL_LINK_TEXT = 'http://sandbox.alexfedoseev.com/sourcebuster/showoff'
  TEST_REFERRAL_SOURCE = 'alexfedoseev.livejournal.com'
  TEST_REFERRAL_MEDIUM = 'referral'


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
	  @browser = Selenium::WebDriver.for TEST_BROWSER
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
	  @browser.switch_to.window(@browser.window_handles.last)
  end

  def visit_from_google
	  @browser.navigate.to 'http://www.google.com'
	  @browser.find_element(:name, 'q').send_keys(SEARCH_QUERY)
	  @browser.find_element(:name, 'q').submit
	  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	  wait.until { @browser.find_element(:partial_link_text, GOOGLE_TITLE).click }
	  @browser.switch_to.window(@browser.window_handles.last)
  end

  def visit_from_custom_organic(search_engine)
		if search_engine == :rambler
			@browser.navigate.to 'http://www.rambler.ru'
			@browser.find_element(:name, 'query').send_keys(SEARCH_QUERY)
			@browser.find_element(:name, 'query').submit
			wait = Selenium::WebDriver::Wait.new(:timeout => 10)
			wait.until { @browser.find_element(:partial_link_text, YANDEX_TITLE).click }
			@browser.switch_to.window(@browser.window_handles.last)
		end
  end

  def visit_from_referral(url, link_text)
	  @browser.navigate.to url
	  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	  wait.until { @browser.find_element(:partial_link_text, link_text).click }
	  @browser.switch_to.window(@browser.window_handles.last)
  end

  def delete_sb_session
		@browser.manage.delete_cookie :sb_session
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


  #######################################################################
  ### Test UTM Overrides

  test "utms are correct, utm -> utm override is correct, utm -> organic yandex override is correct" do

	  # test utm
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test utm -> utm override (same session)
	  visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

	  # test utm -> organic yandex override (same session)
	  visit_from_yandex
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)


	  # test utm (new session)
	  delete_sb_session
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test utm -> utm override (new session)
	  delete_sb_session
	  visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

	  # test utm -> organic yandex override (new session)
	  delete_sb_session
	  visit_from_yandex
	  check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

	test "utm -> organic google override is correct" do

		# test first visit with utms
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> organic google override (same session)
		visit_from_google
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)


		# test first visit with utms (new session)
		delete_sb_session
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> organic google override (new session)
		delete_sb_session
		visit_from_google
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	end

	test "utm -> organic custom override is correct" do

		# test first visit with utms
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> organic custom override (same session)
		visit_from_custom_organic(:rambler)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)


		# test first visit with utms (new session)
		delete_sb_session
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> organic custom override (new session)
		delete_sb_session
		visit_from_custom_organic(:rambler)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	end

	test "utm -> referral common override is correct" do

		# test first visit with utms
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> referral common override (same session)
		visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> referral common override (new session)
		delete_sb_session
		visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	end

	test "utm -> referral custom override is correct" do

		# test first visit with utms
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> referral custom override (same session)
		visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> referral custom override (new session)
		delete_sb_session
		visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	end

	test "utm -> typein override is correct" do

		# test first visit with utms
		visit_with_utms(TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> typein override (same session)
		@browser.navigate.to TEST_URL
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

		# test utm -> typein override (new session)
		delete_sb_session
		@browser.navigate.to TEST_URL
		check_utm_elements(:first, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_2, TEST_UTM_MEDIUM_2, TEST_UTM_CAMPAIGN_2, TEST_UTM_CONTENT_2, TEST_UTM_TERM_2)

	end


  #######################################################################
	### Test Organic Yandex Overrides

	test "organic yandex are correct, organic yandex -> utm override is correct" do

		# test organic yandex
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> utm override (same session)
		visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

		# test organic yandex (new session)
		delete_sb_session
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> utm override (new session)
		delete_sb_session
		visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	end

	test "organic yandex -> organic google override is correct" do

		# test organic yandex
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> organic google override (same session)
		visit_from_google
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)


		# test organic yandex (new session)
		delete_sb_session
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> organic google override (new session)
		delete_sb_session
		visit_from_google
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	end

	test "organic yandex -> organic custom override is correct" do

		# test organic yandex
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> organic custom override (same session)
		visit_from_custom_organic(:rambler)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex (new session)
		delete_sb_session
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> organic custom override (new session)
		delete_sb_session
		visit_from_custom_organic(:rambler)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	end

	test "organic yandex -> referral common override is correct" do

		# test organic yandex
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> referral common override (same session)
		visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> referral common override (new session)
		delete_sb_session
		visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	end

	test "organic yandex -> referral custom override is correct" do

		# test organic yandex
		visit_from_yandex
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> referral custom override (same session)
		visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

		# test organic yandex -> referral custom override (new session)
		delete_sb_session
		visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
		check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
		check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	end

  test "organic yandex -> typein override is correct" do

	  # test organic yandex
	  visit_from_yandex
	  check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic yandex -> typein override (same session)
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic yandex -> typein override (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end


	#######################################################################
	### Test Organic Google Overrides

  test "organic google are correct, organic google -> utm override is correct" do

	  # test organic google
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> utm override (same session)
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test organic google (new session)
	  delete_sb_session
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> utm override (new session)
	  delete_sb_session
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

  end

  test "organic google -> organic yandex override is correct" do

	  # test organic google
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> organic yandex override (same session)
	  visit_from_yandex
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google (new session)
	  delete_sb_session
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> organic yandex override (new session)
	  delete_sb_session
	  visit_from_yandex
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic google -> organic custom override is correct" do

	  # test organic google
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> organic custom override (same session)
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google (new session)
	  delete_sb_session
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> organic custom override (new session)
	  delete_sb_session
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic google -> referral common override is correct" do

	  # test organic google
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> referral common override (same session)
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> referral common override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic google -> referral custom override is correct" do

	  # test organic google
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> referral custom override (same session)
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> referral custom override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic google -> typein override is correct" do

	  # test organic google
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> typein override (same session)
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> typein override (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  #######################################################################
  ### Test Organic Custom Overrides

  test "organic custom are correct, organic custom -> utm override is correct" do

	  # test organic custom
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> utm override (same session)
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test organic custom (new session)
	  delete_sb_session
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> utm override (new session)
	  delete_sb_session
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

  end

  test "organic custom -> organic yandex override is correct" do

	  # test organic custom
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> organic yandex override (same session)
	  visit_from_yandex
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom (new session)
	  delete_sb_session
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> organic yandex override (new session)
	  delete_sb_session
	  visit_from_yandex
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic custom -> organic google override is correct" do

	  # test organic custom
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> organic google override (same session)
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom (new session)
	  delete_sb_session
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> organic google override (new session)
	  delete_sb_session
	  visit_from_google
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic custom -> referral common override is correct" do

	  # test organic custom
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> referral common override (same session)
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> referral common override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic custom -> referral custom override is correct" do

	  # test organic custom
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> referral custom override (same session)
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic google -> referral custom override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "organic custom -> typein override is correct" do

	  # test organic custom
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> typein override (same session)
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test organic custom -> typein override (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end


  #######################################################################
  ### Test Referral Common Overrides

  test "referral common are correct, referral common -> utm override is correct" do

	  # test referral common
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> utm override (same session)
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test referral common (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> utm override (new session)
	  delete_sb_session
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

  end

  test "referral common -> organic yandex override is correct" do

	  # test referral common
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> organic yandex override (same session)
	  visit_from_yandex
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> organic yandex override (new session)
	  delete_sb_session
	  visit_from_yandex
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral common -> organic google override is correct" do

	  # test referral common
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> organic google override (same session)
	  visit_from_google
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> organic google override (new session)
	  delete_sb_session
	  visit_from_google
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral common -> organic custom override is correct" do

	  # test referral common
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> organic custom override (same session)
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> organic custom override (new session)
	  delete_sb_session
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral common -> referral custom override is correct" do

	  # test referral common
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> referral custom override (same session)
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> referral custom override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral common -> typein override is correct" do

	  # test referral common
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> typein override (same session)
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral common -> typein override (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end


  #######################################################################
  ### Test Referral Custom Overrides

  test "referral custom are correct, referral custom -> utm override is correct" do

	  # test referral custom
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> utm override (same session)
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test referral custom (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> utm override (new session)
	  delete_sb_session
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

  end

  test "referral custom -> organic yandex override is correct" do

	  # test referral custom
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> organic yandex override (same session)
	  visit_from_yandex
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> organic yandex override (new session)
	  delete_sb_session
	  visit_from_yandex
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral custom -> organic google override is correct" do

	  # test referral custom
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> organic google override (same session)
	  visit_from_google
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> organic google override (new session)
	  delete_sb_session
	  visit_from_google
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral custom -> organic custom override is correct" do

	  # test referral custom
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> organic custom override (same session)
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> organic custom override (new session)
	  delete_sb_session
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral custom -> referral common override is correct" do

	  # test referral custom
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> referral common override (same session)
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> referral common override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "referral custom -> typein override is correct" do

	  # test referral custom
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> typein override (same session)
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> typein override (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end


  #######################################################################
  ### Test Typein Overrides

  test "typein are correct, typein -> utm override is correct" do

	  # test typein
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> utm override (same session)
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test typein (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

	  # test typein -> utm override (new session)
	  delete_sb_session
	  visit_with_utms(TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_UTM, TEST_UTM_SOURCE_1, TEST_UTM_MEDIUM_1, TEST_UTM_CAMPAIGN_1, TEST_UTM_CONTENT_1, TEST_UTM_TERM_1)

  end

  test "typein -> organic yandex override is correct" do

	  # test typein
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> organic yandex override (same session)
	  visit_from_yandex
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test typein (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> organic yandex override (new session)
	  delete_sb_session
	  visit_from_yandex
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_YANDEX, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "typein -> organic google override is correct" do

	  # test typein
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> organic google override (same session)
	  visit_from_google
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test typein (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> organic google override (new session)
	  delete_sb_session
	  visit_from_google
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, SB_GOOGLE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "typein -> organic custom override is correct" do

	  # test typein
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> organic custom override (same session)
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test typein (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> organic custom override (new session)
	  delete_sb_session
	  visit_from_custom_organic(:rambler)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_ORGANIC, ORGANIC_CUSTOM_ENGINE, SB_REFERER_ORGANIC, SB_NONE, SB_NONE, SB_NONE)

  end

  test "typein -> referral common override is correct" do

	  # test typein
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> referral common override (same session)
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> referral common override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_URL, TEST_REFERRAL_LINK_TEXT)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_SOURCE, TEST_REFERRAL_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "typein -> referral custom override is correct" do

	  # test typein
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> referral custom override (same session)
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> referral custom override (new session)
	  delete_sb_session
	  visit_from_referral(TEST_REFERRAL_CUSTOM_URL, TEST_REFERRAL_CUSTOM_LINK_TEXT)
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_REFERRAL, TEST_REFERRAL_CUSTOM_SOURCE, TEST_REFERRAL_CUSTOM_MEDIUM, SB_NONE, SB_NONE, SB_NONE)

  end

  test "typein -> typein override is correct" do

	  # test typein
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test typein -> typein override (same session)
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

	  # test referral custom -> typein override (new session)
	  delete_sb_session
	  @browser.navigate.to TEST_URL
	  check_utm_elements(:first, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)
	  check_utm_elements(:current, SB_TYPEIN, SB_TYPEIN, SB_TYPEIN, SB_NONE, SB_NONE, SB_NONE)

  end

end

