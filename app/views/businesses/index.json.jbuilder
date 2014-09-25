json.array!(@businesses) do |business|
  json.extract! business, :id, :dba_name, :aka_name, :license, :facility_type, :address, :zip, :latitude, :longitude
  json.url business_url(business, format: :json)
end
