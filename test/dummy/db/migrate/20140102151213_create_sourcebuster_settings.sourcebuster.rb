# This migration comes from sourcebuster (originally 20140102103440)
class CreateSourcebusterSettings < ActiveRecord::Migration
  def change

    create_table :sourcebuster_settings do |t|
      t.integer :session_length
      t.boolean :use_subdomains, default: false
      t.string :main_host

      t.timestamps
    end
    Sourcebuster::Setting.create session_length: 30,
                                 use_subdomains: false

  end
end
