class ResultsController < ApplicationController
  PUBLIC_ACTIONS = [:self_wca_id].freeze
  USER_ACTIONS = [:show, :edit, :update, :create].freeze

  before_action :authenticate_user!, except: PUBLIC_ACTIONS
  before_action :redirect_unless_can_manage_online_competitions!, except: PUBLIC_ACTIONS + USER_ACTIONS
  before_action :set_result, only: [:show, :edit, :update]

  def self_wca_id
    respond_to do |format|
      format.json do
        render json: {
          id: current_user&.id,
          wca_id: current_user&.wca_id,
        }
      end
    end
  end

  # GET /results/1.json
  def show
    {
      value1: 1111,
      value2: 1223,
      value3: 956,
      value4: 1643,
      value5: 1000,
      best: 956,
      average: 1111,
      event_id: "333",
      format_id: "a",
      online_competition_id: 1,
      user_id: 277,
    }
    respond_to do |format|
      format.json { render json: @result.blank? ? { id: nil } : @result.to_json }
    end
  end

  # POST /results
  # POST /results.json
  def create_or_update
    #TODO
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to @result, notice: 'Result was successfully created.' }
        format.json { render :show, status: :created, location: @result }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    #TODO custom set result for admin! (ie: by id)
    @result = Result.find(params[:id])
    @result.destroy
    respond_to do |format|
      format.html { redirect_to results_url, notice: 'Result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @result = Result.where(user_id: current_user.id,
                             online_competition_id: params[:competition_id],
                             event_id: params[:event_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:value0, :value1, :value2, :value3,
                                     :value4, :value5, :best, :average)
    end
end
