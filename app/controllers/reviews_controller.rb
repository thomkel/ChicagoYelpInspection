require 'json'
require 'yelp'

class ReviewsController < ApplicationController

  def results
    location = validate_location(params[:location].upcase)
    parameters = { category_filter: "restaurants", radius_filter: 3200, limit: 10 }
    response, error = validate_response(location, parameters)

    if error.nil?

      @responses = response.businesses     

      @results = []  

      @responses.each do |yelp_business|
        business_id = URI.escape(yelp_business.id)
        business = Yelp.client.business(business_id)
        inspection_info = search_inspections(business)
        business_info = [business.name, business.rating_img_url, inspection_info, business.url]
        @results.push(business_info)
      end
    else
      redirect_to root_url, notice: "#{error}"
    end
  end  

  def validate_location(location)
    if location.include?("CHICAGO")
      return location
    else
      return location + ", CHICAGO, IL"
    end
  end

  def validate_response(location, parameters)
    begin
      @error = nil
      response = Yelp.client.search(location, parameters) 
    rescue Yelp::Error::UnavailableForLocation
      @error = "Not a valid location"
    rescue Yelp::Error::InvalidParameter
      @error = "Not a valid location"
    rescue Yelp::Error::MissingParameter
      @error = "Not a valid location"
    rescue Yelp::Error::InvalidSignature
      @error = "oauth signature is invalid"
    rescue Yelp::Error::InvalidCredentials
      @error = "Yelp username/password not valid"
    rescue Yelp::Error::InvalidOauthCredentials
      @error = "OAuth credentials are not valid"
    rescue Yelp::Error::InvalidOauthUser
      @error = "Oauth user is not valid"
    rescue Yelp::Error::AccountUnconfirmed
      @error = "Yelp account not yet activated"
    rescue Yelp::Error::PasswordTooLong
      @error = "Password too long"
    rescue Yelp::Error::AreaTooLarge
      @error = "Geographical area is too large. Max search area is 2500 sq. miles... way bigger than Chicago!"                                                
    rescue Yelp::Error::MultipleLocations
      @error = "Multiple locations match query"
    rescue Yelp::Error::BusinessUnavailable
      @error = "Business information is unavailable at this time"                
    end

    return response, @error

  end

  def search_inspections(business) 
    address = business.location.address[0].to_s.upcase
    city = business.location.city.to_s.upcase  

    if !city.include?("CHICAGO")
      return [["", "not located in Chicago"]]
    end 

    business_found = search_businesses(Address.where("address LIKE ?", "%#{address}%"), business.name.upcase)

    if business_found.nil? 
      return [["", "no inspections found"]]
    end

    inspections = Inspection.where(:business_id => business_found).order(inspect_date: :desc)
    @inspect_results = []

    inspections.each do |inspection|
      if (inspection.results.include?("Pass") || inspection.results.include?("Fail"))
        inspect_date = format_date(inspection.inspect_date)
        inspection_data = [inspect_date, inspection.results, inspection.violations, inspection.id]
        @inspect_results.push(inspection_data)
      end
    end

    return @inspect_results

  end

  def search_businesses(addresses, name)
    name = name.split(" ")
    name = name[0].gsub(/[^a-z0-9]/i, '')

    if addresses.empty?
      return nil
    end

    business_ids = addresses.select(:business_id).distinct

    if business_ids.count == 1
      business = business_ids[0].business_id
      return business
    else
      business_ids.each do |business_id|
        business = Business.find_by(:id => business_id.business_id)
        dba = business.dba_name.upcase
        aka = business.aka_name.upcase

        if (dba.include?(name) || aka.include?(name))
          return business.id
        end
      end

      return nil
    end

  end

  def format_date(date)
    month = Date::MONTHNAMES[date.mon]
    year = date.year

    return month[0..2] + " " + year.to_s 
  end

  def howto
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.permit(:dba_name, :aka_name, :license, :facility_type, :address, :zip, :latitude, :longitude, :location)
    end
end
