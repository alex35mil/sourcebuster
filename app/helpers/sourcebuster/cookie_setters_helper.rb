module Sourcebuster
  module CookieSettersHelper

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

		def set_sourcebuster_cookies
			cookies.permanent[:sb_current] = get_main_sb_data if get_main_sb_data
			cookies.permanent[:sb_first_add] = "#{SB_FIRST_DATE}=#{Time.now}|#{SB_ENTRANCE_POINT}=#{request.original_url}" unless cookies[:sb_first]
			cookies.permanent[:sb_first] = cookies[:sb_current] unless cookies[:sb_first]
			cookies[:sb_session] = { value: '1', expires: 30.minutes.from_now }
			cookies[:sb_udata] = "#{SB_USER_IP}=#{request.remote_ip}|#{SB_USER_AGENT}=#{request.user_agent}"
		end

		def combine_sb_main_data_string(sb_type, sb_source, sb_medium, sb_campaign, sb_content, sb_term)
			"#{SB_TYPE_ALIAS}=#{sb_type}|" +
			"#{SB_SOURCE_ALIAS}=#{sb_source}|" +
			"#{SB_MEDIUM_ALIAS}=#{sb_medium}|" +
			"#{SB_CAMPAIGN_ALIAS}=#{sb_campaign}|" +
			"#{SB_CONTENT_ALIAS}=#{sb_content}|" +
			"#{SB_TERM_ALIAS}=#{sb_term}"
		end

		def clean_host(request)
			URI(request).host.gsub('www.','')
		end

		def get_main_sb_data
			if params[:utm_source] || params[:utm_medium] || params[:utm_campaign] || params[:utm_content] || params[:utm_term]
				get_data(SB_UTM)
			elsif check_referer(SB_ORGANIC)
				get_data(SB_ORGANIC)
			elsif !cookies[:sb_session] && check_referer(SB_REFERRAL)
				cookies[:sb_referer] = request.referer unless request.referer.blank?
				get_data(SB_REFERRAL)
			elsif !cookies[:sb_first] && !cookies[:sb_current]
				get_data(SB_TYPEIN)
			else
				false
			end
		end

		def check_referer(type)
			if type == SB_ORGANIC
				!request.referer.blank? &&
				clean_host(request.referer) != clean_host(request.original_url) &&
				URI(request.referer).host &&
				organic?(request.referer)
			elsif type == SB_REFERRAL
				!request.referer.blank? &&
				clean_host(request.referer) != clean_host(request.original_url) &&
				social_or_another?(request.referer)
			else
				false
			end
		end

		def organic?(referer)
			y_host = 'yandex'
			y_param = 'text'
			g_host = 'google'

			if !!URI(referer).query && !!URI(referer).host.match(/^.*\.?#{y_host}\..{2,9}$/) && !!URI(referer).query.match(/.*[?&]#{y_param}=.*/)
				@sb_source = y_host
			elsif !!URI(referer).host.match(/^(www\.)?#{g_host}\..{2,9}$/)
				@sb_source = g_host
			elsif get_add_organic_sources(referer)
				@sb_source = get_add_organic_sources(referer)
			else
				false
			end
		end

		def get_add_organic_sources(referer)
			organic_type_id = Sourcebuster::RefererType.where(referer_type: SB_REFERER_ORGANIC).first.id
			organic_array = Sourcebuster::RefererSource.where(referer_type_id: organic_type_id)

			organic_array.each do |src|
				return (src.source_alias || src.domain) if !!URI(referer).host.match(/^.*\.?#{src.domain}$/) && !!URI(referer).query.match(/.*[?&]#{src.organic_query_param}=.*/)
			end
			false
		end

		def social_or_another?(referer)
			if check_social_referer_type(referer)
				@sb_source = check_social_referer_type(referer)
				@sb_medium = SB_REFERER_SOCIAL
			else
				@sb_source = clean_host(referer)
			end
		end

		def check_social_referer_type(referer)
			social_type_id = Sourcebuster::RefererType.where(referer_type: SB_REFERER_SOCIAL).first.id
			social_array = Sourcebuster::RefererSource.where(referer_type_id: social_type_id)

			social_array.each do |src|
				return (src.source_alias || src.domain) if !!URI(referer).host.match(/^.*\.?#{src.domain}$/)
			end
			false
		end

		def get_data(type)

			case type

			when SB_UTM

				@sb_type = SB_UTM
				@sb_source = params[:utm_source] || SB_NONE
				@sb_medium = params[:utm_medium] || SB_NONE
				@sb_campaign = params[:utm_campaign] || SB_NONE
				@sb_content = params[:utm_content] || SB_NONE
				@sb_term = params[:utm_term] || SB_NONE

			when SB_ORGANIC

				@sb_type = SB_ORGANIC
				@sb_source = clean_host(request.referer) unless @sb_source
				@sb_medium = SB_REFERER_ORGANIC
				@sb_campaign = SB_NONE
				@sb_content = SB_NONE
				@sb_term = SB_NONE

			when SB_REFERRAL

				@sb_type = SB_REFERRAL
				@sb_source = clean_host(request.referer) unless @sb_source
				@sb_medium = SB_REFERER_REFERRAL unless @sb_medium
				@sb_campaign = SB_NONE
				@sb_content = SB_NONE
				@sb_term = SB_NONE

			when SB_TYPEIN

				@sb_type = SB_TYPEIN
				@sb_source = SB_TYPEIN
				@sb_medium = SB_TYPEIN
				@sb_campaign = SB_NONE
				@sb_content = SB_NONE
				@sb_term = SB_NONE

				else

					@sb_type = SB_NONE
					@sb_source = SB_NONE
					@sb_medium = SB_NONE
					@sb_campaign = SB_NONE
					@sb_content = SB_NONE
					@sb_term = SB_NONE

			end

			combine_sb_main_data_string(@sb_type, @sb_source, @sb_medium, @sb_campaign, @sb_content, @sb_term)

		end


		def extract_sourcebuster_data(cookie_type, data)

			cookie = cookies[cookie_type]

			if cookie
				array = CGI::unescape(cookie).split('|')
				data_hash = {}

				array.each do |param|
					data_hash.merge!(param.split('=', 2)[0].to_sym => param.split('=', 2)[1])
				end

				data_hash[data]
			else
				'(Houston, we have a problem)'
			end

		end

  end
end
