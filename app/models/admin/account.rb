class Admin::Account < ActiveRecord::Base
  #has_one :setting, :dependent => :destroy
  belongs_to :setting
  accepts_nested_attributes_for :setting
  #attr_accessor :id

  
  # Internal getter for other controllers.  If host is not given
  # look it up using the request
  def self.get_saml_settings(host)
    # Grab the ActiveRecord Setting object from the Account
    setting_AR = Admin::Account.find(:all, :conditions => { :host => host } ).first
    return nil if setting_AR == nil

    setting_AR = setting_AR.setting

    # Create a new Onelogin version of the similarly defined class
    setting_SAML = Onelogin::Saml::Settings.new

    # And copy those settings into the Onelogin object for use in the rest of the Onelogin namespace
    # (I'm guessing there's probably a better way to do this!)
    if setting_AR.assertion_consumer_service_url != nil
      setting_SAML.assertion_consumer_service_url = setting_AR.assertion_consumer_service_url
    end
    if setting_AR.assertion_consumer_service_binding != nil
      setting_SAML.assertion_consumer_service_binding = setting_AR.assertion_consumer_service_binding
    end
    if setting_AR.single_logout_service_url != nil
      setting_SAML.single_logout_service_url = setting_AR.single_logout_service_url
    end
    if setting_AR.single_logout_service_binding != nil
      setting_SAML.single_logout_service_binding = setting_AR.single_logout_service_binding
    end
    if setting_AR.issuer != nil
      setting_SAML.issuer = setting_AR.issuer
    end
    if setting_AR.idp_sso_target_url != ""
      setting_SAML.idp_sso_target_url = setting_AR.idp_sso_target_url
    end
    if setting_AR.idp_cert_fingerprint != ""
      setting_SAML.idp_cert_fingerprint = setting_AR.idp_cert_fingerprint
    end
    if setting_AR.name_identifier_format != ""
      setting_SAML.name_identifier_format = setting_AR.name_identifier_format
    end
    if setting_AR.authn_context != ""
      setting_SAML.authn_context = setting_AR.authn_context
    end
    if setting_AR.idp_metadata != ""
      setting_SAML.idp_metadata = setting_AR.idp_metadata
    end
    if setting_AR.idp_metadata_ttl != nil
      setting_SAML.idp_metadata_ttl = setting_AR.idp_metadata_ttl
    end

    # return the Onelogin version of the Settings object
    return setting_SAML
  end   

end
