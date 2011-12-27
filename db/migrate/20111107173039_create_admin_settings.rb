class CreateAdminSettings < ActiveRecord::Migration
  def change
    create_table :admin_settings do |t|
      t.string :assertion_consumer_service_url
      t.string :assertion_consumer_service_binding
      t.string :single_logout_service_url
      t.string :single_logout_service_binding
      t.string :idp_metadata
      t.integer :idp_metadata_ttl
      t.string :name_identifier_format
      t.string :issuer
      t.string :authn_context
      t.string :idp_cert_fingerprint
      t.string :idp_sso_target_url

      t.timestamps
    end
  end
end
