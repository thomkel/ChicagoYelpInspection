require 'json'
require 'yelp'

class BusinessesController < ApplicationController
  before_action :set_business, only: [:show]

  # GET /businesses
  # GET /businesses.json
  
  def index
    @businesses = Business.all
  end

  def search
  end

  # def results
  #   @location = params[:location]

  #   parameters = { term: "food", limit: 10 }
  #   response = Yelp.client.search(@location, parameters) 
  #   @responses = response.businesses 
  #   @results = []  

  #   @responses.each do |yelp_business|
  #     business_id = URI.escape(yelp_business.id)
  #     business = Yelp.client.business(business_id)
  #     inspection_info = search_inspections(business)
  #     business_info = [business.name, business.rating_img_url, inspection_info, business.url]
  #     @results.push(business_info)
  #   end
  # end  

  # def search_inspections(business) 
  #   address = business.location.address[0].to_s.upcase
  #   business_found = Address.find_by("address LIKE ?", "%#{address}%")

  #   if business_found.nil?
  #     return [["", "no inspections found"]]
  #   end

  #   inspections = Inspection.where(:business_id => business_found.business_id).order(inspect_date: :desc)
  #   @inspect_results = []

  #   inspections.each do |inspection|
  #     if (inspection.results.include?("Pass") || inspection.results.include?("Fail"))
  #       inspection_data = [inspection.inspect_date, inspection.results, inspection.violations, inspection.id]
  #       @inspect_results.push(inspection_data)
  #     end
  #   end

  #   return @inspect_results

  # end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = Business.new(business_params)

    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: 'Business was successfully created.' }
        format.json { render action: 'show', status: :created, location: @business }
      else
        format.html { render action: 'new' }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url }
      format.json { head :no_content }
    end
  end

  private
    Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_params
      params.permit(:dba_name, :aka_name, :license, :facility_type, :address, :zip, :latitude, :longitude, :location)
    end
end
