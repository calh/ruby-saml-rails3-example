class SamlController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:consume, :logout]
  # Handy method to lookup settings/account
  before_filter :setup

  # This is the first hit method that starts the SAML request flow 
  def index
    # redirect to our setup page if nothing is defined
    # (the out-of-box n00b page)
    if @settings.nil?
      render :action => :no_settings
      return 
    end

    request = Onelogin::Saml::Authrequest.new(@settings)

    # Create the request, returning an action type and associated content
    action, content = request.create
    case action
    when "GET"
      # for GET requests, do a redirect on the content
      redirect_to content
    when "POST"
      # for POST requests (form) render the content as HTML
      render :inline => content
    end
  end

  def consume
    @response = Onelogin::Saml::Response.new(params[:SAMLResponse])
    @response.settings = @settings
    logger.info "NAMEID: #{@response.name_id}"

    respond_to do |format|
      if @response.is_valid?
        session[:userid] = @response.name_id
        session[:attributes] = @response.attributes
        format.html {
          if session[:goback_to] != nil
            redirect_to session[:goback_to]
          else  
            render :action => :complete 
          end
        }
      else
        #redirect_to :action => :fail
        format.html { render :action => :fail }
      end
    end
  end

  def complete
  end

  def fail
  end

  # Trigger SP and IdP initiated Logout requests
  def logout
    # If we're given a logout request, handle it in the IdP initiated method
    if params[:SAMLRequest]
      return idp_logout_request
    end
    # We've been given a response back from the IdP 
    if params[:SAMLResponse]
      return logout_response
    end

    # No parameters means the browser hit this method directly.
    # Start the SP initiated SLO
    sp_logout_request
  end

  # Create an SP initiated SLO
  def sp_logout_request

    # LogoutRequest accepts plain browser requests w/o paramters 
    logout_request = Onelogin::Saml::LogoutRequest.new( :settings => @settings )

    # Since we created a new SAML request, save the transaction_id 
    # to compare it with the response we get back
    session[:transaction_id] = logout_request.transaction_id

    logger.info "New SP SLO for userid '#{session[:userid]}'"

    # Create a new LogoutRequest for this session Name ID
    action, content = logout_request.create( :name_id => session[:userid] )
    case action
    when "GET"
      # for GET requests, do a redirect on the content
      redirect_to content
    when "POST"
      # for POST requests (form) render the content as HTML
      render :inline => content
    end
  end

  # After sending an SP initiated LogoutRequest to the IdP, we need to accept
  # the LogoutResponse, verify it, then actually delete our session.
  def logout_response
    logout_response = Onelogin::Saml::LogoutResponse.new( :response => params[:SAMLResponse], :settings => @settings )

    logger.info "LogoutResponse is: #{logout_response.to_s}"

    # If the IdP gave us a signed response, verify it
    unless logout_response.is_valid?
      logger.error "The SAML Response signature validation failed"
      # For each error, add in some custom failure for your app
    end
    if session[:transation_id] && logout_response.in_response_to != session[:transaction_id]
      logger.error "The SAML Response for #{logout_response.in_response_to} does not match our session transaction ID of #{session[:transaction_id]}"
      # For each error, add in some custom failure for your app
    end

    # Optional sanity check
    if logout_response.issuer != @settings.idp_metadata
      logger.error "The SAML Response from IdP #{logout_response.issuer} does not match our trust relationship with #{@settings.idp_metadata}"
      # For each error, add in some custom failure for your app
    end

    # Actually log out this session
    if logout_response.success?
      logger.info "Delete session for '#{session[:userid]}'"
      delete_session
    end
  end

  # Method to handle IdP initiated logouts
  def idp_logout_request
    logout_request = Onelogin::Saml::LogoutRequest.new( :request => params[:SAMLRequest], :settings => @settings)
    unless logout_request.is_valid?
      logger.error "IdP initiated LogoutRequest was not valid!"
    end
    # Check that the name ID's match
    if session[:userid] != logout_request.name_id
      logger.error "The session's Name ID '#{session[:userid]}' does not match the LogoutRequest's Name ID '#{logout_request.name_id}'"
    end
    logger.info "IdP initiated Logout for #{logout_request.name_id}"

    # Actually log out this session
    delete_session

    # Generate a response to the IdP.  :transaction_id sets the InResponseTo
    # SAML message to create a reply to the IdP in the LogoutResponse.
    action, content = logout_response = Onelogin::Saml::LogoutResponse.new(:settings => @settings).
      create(:transaction_id => logout_request.transaction_id)

    case action
      when "GET"
        # for GET requests, do a redirect on the content
        redirect_to content
      when "POST"
        # for POST requests (form) render the content as HTML
        render :inline => content
    end
  end


  # This is the method the IdP will query to retrieve our metadata.
  # Give this path to the IdP administrator
  def metadata
    if @settings.nil?
      render :action => :no_settings
      return
    end

    meta = Onelogin::Saml::Metadata.new(@settings)
    render :xml => meta.generate
  end

  private 

  # This creates the settings object needed for most of the functions
  def setup
    @settings = Admin::Account.get_saml_settings( request.host )
    # This is handy if you have other attributes added to the Admin::Account wrapper.
    #@account = Admin::Account.find(:all, :conditions => { :host => request.host }).first
  end

  # Delete a user's session.  Add your own custom stuff in here 
  def delete_session
    session[:userid] = nil
    session[:attributes] = nil
  end
end
