class Admin::Setting < ActiveRecord::Base
  #belongs_to :admin_account
  #belongs_to :account
  has_one :account
  #accepts_nested_attributes_for :admin_account
  
end
