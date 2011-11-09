class Admin::SettingsController < Admin::BaseController
  # GET /admin/settings
  # GET /admin/settings.json
  def index
    @admin_settings = Admin::Setting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admin_settings }
    end
  end

  # GET /admin/settings/1
  # GET /admin/settings/1.json
  def show
    @admin_setting = Admin::Setting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @admin_setting }
    end
  end

  # GET /admin/settings/new
  # GET /admin/settings/new.json
  def new
    @admin_setting = Admin::Setting.new
    @admin_setting.name_identifier_format = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
    @admin_setting.issuer = request.scheme + "://" + request.host
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @admin_setting }
    end
  end

  # GET /admin/settings/1/edit
  def edit
    @admin_setting = Admin::Setting.find(params[:id])
  end

  # POST /admin/settings
  # POST /admin/settings.json
  def create
    @admin_setting = Admin::Setting.new(params[:admin_setting])

    respond_to do |format|
      if @admin_setting.save
        format.html { redirect_to @admin_setting, :notice => 'Setting was successfully created.' }
        format.json { render :json => @admin_setting, :status => :created, :location => @admin_setting }
      else
        format.html { render :action => "new" }
        format.json { render :json => @admin_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/settings/1
  # PUT /admin/settings/1.json
  def update
    @admin_setting = Admin::Setting.find(params[:id])

    respond_to do |format|
      if @admin_setting.update_attributes(params[:admin_setting])
        format.html { redirect_to @admin_setting, :notice => 'Setting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @admin_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/settings/1
  # DELETE /admin/settings/1.json
  def destroy
    @admin_setting = Admin::Setting.find(params[:id])
    @admin_setting.destroy

    respond_to do |format|
      format.html { redirect_to admin_settings_url }
      format.json { head :ok }
    end
  end
end
