class SamlController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:consume]

  # This is the first hit method that starts the SAML request flow 
  def index
    settings = Admin::Account.get_saml_settings( request.host )
	# redirect to our setup page if nothing is defined
	# (the out-of-box n00b page)
    if settings.nil?
	render :action => :no_settings
	return 
    end

    request = Onelogin::Saml::Authrequest.new(settings)

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
	@response.settings = Admin::Account.get_saml_settings( request.host )
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

  # This is the method the IdP will query to retrieve our metadata.
  # Give this path to the IdP administrator
  def metadata
    settings = Admin::Account.get_saml_settings( request.host )
    if settings.nil?
	render :action => :no_settings
	return 
    end

    meta = Onelogin::Saml::Metadata.new
    render :xml => meta.generate(settings)
  end
end
