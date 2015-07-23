class Farmer < ActiveRecord::Base
  attr_accessible :email, :farm, :name, :produce, :produce_price, :wepay_access_token, :wepay_account_id, :password

  validates :password, :presence => true
  validates :password, :length => { :in => 6..200}
  validates :name, :email, :presence => true
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :format => { :with => /@/, :message => " is invalid" }

  def password
    password_hash ? @password ||= BCrypt::Password.new(password_hash) : nil
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(email, test_password)
    farmer = Farmer.find_by_email(email)
    if farmer && farmer.password == test_password
      farmer
    else
      nil
    end
  end

  # get the authorization url for this farmer. This url will let the farmer
  # register or login to WePay to approve our app.

  # returns a url
  def wepay_authorization_url(redirect_uri)
    Wefarm::Application::WEPAY.oauth2_authorize_url(redirect_uri, self.email, self.name)
  end

  # takes a code returned by wepay oauth2 authorization and makes an api call to generate oauth2 token for this farmer.
  # def request_wepay_access_token(code, redirect_uri)
  #   response = Wefarm::Application::WEPAY.oauth2_token(code, redirect_uri)
  #   if response['error']
  #     raise "Error - "+ response['error_description']
  #   elsif !response['access_token']
  #     raise "Error requesting access from WePay"
  #   else
  #     self.wepay_access_token = response['access_token']
  #     self.save
  #   end
  # end

  # def has_wepay_access_token?
  #   !self.wepay_access_token.nil?
  # end

  # makes an api call to WePay to check if current access token for farmer is still valid
  def has_valid_wepay_access_token?
    if self.wepay_access_token.nil?
      return false
    end
    response = Wefarm::Application::WEPAY.call("/user", self.wepay_access_token)
    response && response["user_id"] ? true : false
  end

  # takes a code returned by wepay oauth2 authorization and makes an api call to generate oauth2 token for this farmer.
  def request_wepay_access_token(code, redirect_uri)
    response = Wefarm::Application::WEPAY.oauth2_token(code, redirect_uri)
    if response['error']
      raise "Error - "+ response['error_description']
    elsif !response['access_token']
      raise "Error requesting access from WePay"
    else
      self.wepay_access_token = response['access_token']
      self.save

    #create WePay account
      self.create_wepay_account
    end
  end

  def has_wepay_account?
    self.wepay_account_id != 0 && !self.wepay_account_id.nil?
  end

  # creates a WePay account for this farmer with the farm's name
  def create_wepay_account
    if self.has_wepay_access_token? && !self.has_wepay_account?
      params = { :name => self.farm, :description => "Farm selling " + self.produce }     
      response = Wefarm::Application::WEPAY.call("/account/create", self.wepay_access_token, params)

      if response["account_id"]
        self.wepay_account_id = response["account_id"]
        return self.save
      else
        raise "Error - " + response["error_description"]
      end

    end   
    raise "Error - cannot create WePay account"
  end
end
