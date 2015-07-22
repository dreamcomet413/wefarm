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
end