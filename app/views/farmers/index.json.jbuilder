json.array!(@farmers) do |farmer|
  json.extract! farmer, :id, :name, :email, :password_hash, :farm, :produce, :produce_price, :wepay_access_token, :wepay_account_id
  json.url farmer_url(farmer, format: :json)
end
