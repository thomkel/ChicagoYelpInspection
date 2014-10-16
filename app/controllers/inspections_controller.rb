class InspectionsController < ApplicationController
  before_action :set_inspection, only: [:show]

  # GET /inspections
  # GET /inspections.json
  def index
    @inspections = Inspection.all
  end

  # GET /inspections/1
  # GET /inspections/1.json
  def show
    violations = @inspection.violations

    if violations.nil?
      @violations = [["No inspection details on record"]]
    else
      @violations = violations.split("|")
    end
  end

  # GET /inspections/new
  def new
    @inspection = Inspection.new
  end

  # GET /inspections/1/edit
  def edit
  end

  # POST /inspections
  # POST /inspections.json
  def create
    @inspection = Inspection.new(inspection_params)

    respond_to do |format|
      if @inspection.save
        format.html { redirect_to @inspection, notice: 'Inspection was successfully created.' }
        format.json { render action: 'show', status: :created, location: @inspection }
      else
        format.html { render action: 'new' }
        format.json { render json: @inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inspections/1
  # PATCH/PUT /inspections/1.json
  def update
    respond_to do |format|
      if @inspection.update(inspection_params)
        format.html { redirect_to @inspection, notice: 'Inspection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inspections/1
  # DELETE /inspections/1.json
  def destroy
    @inspection.destroy
    respond_to do |format|
      format.html { redirect_to inspections_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inspection
      @inspection = Inspection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inspection_params
      params.require(:inspection).permit(:inspect_id, :inspect_date, :results, :violations)
    end
end
