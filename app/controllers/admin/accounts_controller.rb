class Admin::AccountsController < Admin::BaseController
  # GET /admin/accounts
  # GET /admin/accounts.json
  def index
    @admin_accounts = Admin::Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admin_accounts }
    end
  end

  # GET /admin/accounts/1
  # GET /admin/accounts/1.json
  def show
    @admin_account = Admin::Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @admin_account }
    end
  end

  # GET /admin/accounts/new
  # GET /admin/accounts/new.json
  def new
    @admin_account = Admin::Account.new
    @admin_account.build_setting
    @admin_account.setting.assertion_consumer_service_url = request.scheme + "://" + request.host + "/saml/consume"
    @admin_account.setting.single_logout_service_url = request.scheme + "://" + request.host + "/saml/logout"
    @admin_account.setting.name_identifier_format = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
    @admin_account.setting.issuer = request.scheme + "://" + request.host

    #@admin_account.setting = Admin::Setting.new 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @admin_account }
    end
  end

  # GET /admin/accounts/1/edit
  def edit
    @admin_account = Admin::Account.find(params[:id])
  end

  # POST /admin/accounts
  # POST /admin/accounts.json
  def create
    @admin_account = Admin::Account.new(params[:admin_account])

    respond_to do |format|
      if @admin_account.save
        format.html { redirect_to @admin_account, :notice => 'Account was successfully created.' }
        format.json { render :json => @admin_account, :status => :created, :location => @admin_account }
      else
        format.html { render :action => "new" }
        format.json { render :json => @admin_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/accounts/1
  # PUT /admin/accounts/1.json
  def update
    @admin_account = Admin::Account.find(params[:id])

    respond_to do |format|
      if @admin_account.update_attributes(params[:admin_account])
        format.html { redirect_to @admin_account, :notice => 'Account was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @admin_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/accounts/1
  # DELETE /admin/accounts/1.json
  def destroy
    @admin_account = Admin::Account.find(params[:id])
    @admin_account.destroy

    respond_to do |format|
      format.html { redirect_to admin_accounts_url }
      format.json { head :ok }
    end
  end
end
