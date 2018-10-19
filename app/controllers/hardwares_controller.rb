class HardwaresController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_authorized_delegate!
  before_action :set_hardware, only: [:show, :edit, :update, :destroy]

  # GET /hardwares
  # GET /hardwares.json
  def index
    @hardwares = Hardware.includes({ owners: :user, bag: { owners: :user } }).all
  end

  # GET /hardwares/1
  # GET /hardwares/1.json
  def show
  end

  # GET /hardwares/new
  def new
    @hardware = Hardware.new
  end

  # GET /hardwares/1/edit
  def edit
  end

  # POST /hardwares
  # POST /hardwares.json
  def create
    @hardware = Hardware.new(hardware_params)

    if @hardware.save
      redirect_to @hardware, flash: { success: 'Hardware was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /hardwares/1
  # PATCH/PUT /hardwares/1.json
  def update
    if @hardware.update(hardware_params)
      redirect_to @hardware, flash: { success: 'Hardware was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /hardwares/1
  # DELETE /hardwares/1.json
  def destroy
    @hardware.destroy
    redirect_to hardwares_url, flash: { success: 'Hardware was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware
      @hardware = Hardware.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_params
      params.require(:hardware).permit(
        :name,
        :hardware_type,
        :bag_id,
        :state,
        :comment,
        owners_attributes: [:id, :item_id, :item_type, :user_id, :start, :end, :_destroy],
      )

    end
end
