class CreateDbStructure < ActiveRecord::Migration
	def change

		create_table :sourcebuster_referer_types do |t|
			t.string :referer_type, null: false

			t.timestamps
		end
		add_index :sourcebuster_referer_types, :referer_type, unique: true
		Sourcebuster::RefererType.create referer_type: 'referral'
		Sourcebuster::RefererType.create referer_type: 'organic'
		Sourcebuster::RefererType.create referer_type: 'social'
		Sourcebuster::RefererType.create referer_type: 'email'


		create_table :sourcebuster_referer_sources do |t|
			t.string :domain, null: false
			t.string :source_alias
			t.integer :referer_type_id, null: false
			t.string :organic_query_param

			t.timestamps
		end
		add_index :sourcebuster_referer_sources, :domain
		add_index :sourcebuster_referer_sources, :referer_type_id
		add_index :sourcebuster_referer_sources, :organic_query_param
		Sourcebuster::RefererSource.create domain: "go.mail.ru",
		                                   source_alias: "mail.ru",
		                                   referer_type_id: 2,
		                                   organic_query_param: "q"
		Sourcebuster::RefererSource.create domain: "rambler.ru",
		                                   source_alias: "rambler.ru",
		                                   referer_type_id: 2,
		                                   organic_query_param: "query"
		Sourcebuster::RefererSource.create domain: "yahoo.com",
		                                   source_alias: "yahoo.com",
		                                   referer_type_id: 2,
		                                   organic_query_param: "p"
		Sourcebuster::RefererSource.create domain: "bing.com",
		                                   source_alias: "bing.com",
		                                   referer_type_id: 2,
		                                   organic_query_param: "q"
		Sourcebuster::RefererSource.create domain: "facebook.com",
		                                   source_alias: "facebook",
		                                   referer_type_id: 3
		Sourcebuster::RefererSource.create domain: "twitter.com",
		                                   source_alias: "twitter",
		                                   referer_type_id: 3
		Sourcebuster::RefererSource.create domain: "t.co",
		                                   source_alias: "twitter",
		                                   referer_type_id: 3
		Sourcebuster::RefererSource.create domain: "plus.url.google.com",
		                                   source_alias: "google_plus",
		                                   referer_type_id: 3
		Sourcebuster::RefererSource.create domain: "vk.com",
		                                   source_alias: "vkontakte",
		                                   referer_type_id: 3
		Sourcebuster::RefererSource.create domain: "livejournal.com",
		                                   source_alias: "livejournal.com",
		                                   referer_type_id: 3
		end
end
