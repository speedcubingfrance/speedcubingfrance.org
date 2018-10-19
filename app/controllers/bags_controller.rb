class BagsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_authorized_delegate!
  before_action :set_bag, only: [:show, :edit, :update, :destroy]

  # GET /bags
  # GET /bags.json
  def index
    @bags = Bag.includes({ owners: :user, hardwares: [] }).all
  end

  # GET /bags/1
  # GET /bags/1.json
  def show
  end

  # GET /bags/new
  def new
    @bag = Bag.new
  end

  # GET /bags/1/edit
  def edit
  end

  # POST /bags
  # POST /bags.json
  def create
    @bag = Bag.new(bag_params)

    if @bag.save
      redirect_to @bag, flash: { success: 'Bag was successfully created.' }
    else
      render :new
    end
  end

  # PATCH/PUT /bags/1
  # PATCH/PUT /bags/1.json
  def update
    if @bag.update(bag_params)
      redirect_to @bag, flash: { success: 'Bag was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /bags/1
  # DELETE /bags/1.json
  def destroy
    @bag.destroy
    redirect_to bags_url, flash: { success: 'Bag was successfully destroyed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bag
      @bag = Bag.includes(:hardwares).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bag_params
      params.require(:bag).permit(
        :name,
        owners_attributes: [:id, :item_id, :item_type, :user_id, :start, :end, :_destroy],
      )
    end
end
