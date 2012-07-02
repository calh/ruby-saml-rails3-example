# This is just an example scaffold to show how 
# the authentication hooks should work in your application.

class StuffsController < ApplicationController
  #  The before_filter calls authenticate below.  
  # Uncomment to force authentication for the entire Stuff controller
  #before_filter :authenticate
  # GET /stuffs
  # GET /stuffs.json
  def index
    @stuffs = Stuff.all
    # Look up the settings object to provide a log out link in the view
    @settings = Admin::Account.get_saml_settings( request.host )

    if @settings.nil?
      return redirect_to '/saml'
    end

    # If we're viewing this unauthenticated, set our goback URL for after logging in
    if session[:userid].nil?
      session[:goback_to] = request.url
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @stuffs }
    end
  end

  # GET /stuffs/1
  # GET /stuffs/1.json
  def show
    @stuff = Stuff.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @stuff }
    end
  end

  # GET /stuffs/new
  # GET /stuffs/new.json
  def new
    @stuff = Stuff.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @stuff }
    end
  end

  # GET /stuffs/1/edit
  def edit
    @stuff = Stuff.find(params[:id])
  end

  # POST /stuffs
  # POST /stuffs.json
  def create
    @stuff = Stuff.new(params[:stuff])

    respond_to do |format|
      if @stuff.save
        format.html { redirect_to @stuff, :notice => 'Stuff was successfully created.' }
        format.json { render :json => @stuff, :status => :created, :location => @stuff }
      else
        format.html { render :action => "new" }
        format.json { render :json => @stuff.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stuffs/1
  # PUT /stuffs/1.json
  def update
    @stuff = Stuff.find(params[:id])

    respond_to do |format|
      if @stuff.update_attributes(params[:stuff])
        format.html { redirect_to @stuff, :notice => 'Stuff was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @stuff.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stuffs/1
  # DELETE /stuffs/1.json
  def destroy
    @stuff = Stuff.find(params[:id])
    @stuff.destroy

    respond_to do |format|
      format.html { redirect_to stuffs_url }
      format.json { head :ok }
    end
  end

  private

  def authenticate
    unless logged_in?
      # Save our current path in the session to return back to
      # after logging in.  (Saml controller looks for this)
      logger.info "Goback URL is '#{request.url}'"
      session[:goback_to] = request.url
      redirect_to saml_url
    end
  end

  def logged_in?
    return false if session[:userid].nil?
    return false if session[:userid] == ""
    return true
  end
end
