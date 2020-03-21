class ResultsController < ApplicationController
  PUBLIC_ACTIONS = [:self_wca_id, :index_for_comp].freeze
  USER_ACTIONS = [:show, :create_or_update].freeze

  before_action :authenticate_user!, except: PUBLIC_ACTIONS
  before_action :redirect_unless_can_manage_online_competitions!, except: PUBLIC_ACTIONS + USER_ACTIONS
  before_action :set_result, only: USER_ACTIONS
  before_action :check_competition_ongoing, only: USER_ACTIONS
  before_action :check_competition_over, only: :index_for_comp

  def self_wca_id
    respond_to do |format|
      format.json do
        if current_user
          render json: {
            id: current_user.id,
            wca_id: current_user.wca_id,
            name: current_user.name,
            can_manage_online_comps: current_user.can_manage_online_comps?,
          }
        else
          render json: { id: nil }
        end
      end
    end
  end

  def index_for_comp
    @comp = OnlineCompetition.find(params.require(:competition_id))
    @event = Event.c_find!(params.require(:event_id))
    rank_first = @event.format.sort_by == "single" ? "best" : "average"
    rank_second = @event.format.sort_by_second == "single" ? "best" : "average"
    @results = Result
      .includes(:user)
      .select("results.*, rank() over(order by #{rank_first} asc, #{rank_second} asc) pos")
      .where(online_competition: @comp, event: @event)
    respond_to do |format|
      format.json do
        render json: @results.to_json
      end
    end
  end

  # GET /results/:event_id/:online_competition_id.json
  def show
    respond_to do |format|
      format.json { render json: @result.to_json }
    end
  end

  def create_or_update
    @result.assign_attributes(result_params)
    respond_to do |format|
      # if result exists and everything is skipped, delete it
      if @result.id && @result.solve_times.all? { |s| s.dns? || s.skipped? }
        @result.destroy
        format.json { render json: { status: :ok } }
      elsif @result.save
        format.json { render json: { status: :ok } }
      else
        format.json { render json: { errors: @result.errors.map { |key, val| "#{key}: #{val}" }, status: :ok } }
      end
    end
  end

  def destroy
    @result = Result.find(params[:id])
    comp_id = @result.online_competition_id
    @result.destroy
    redirect_to admin_results_path(comp_id), flash: {
      success: 'Result was successfully destroyed.'
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @comp = OnlineCompetition.find(params.require(:competition_id))
      @event = Event.c_find!(params.require(:event_id))

      @result = Result.where(user_id: current_user.id,
                             online_competition_id: @comp.id,
                             event_id: @event.id).first
      @result ||= Result.new(user: current_user, online_competition: @comp,
                             event: @event, format_id: @event.preferred_format)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:value1, :value2, :value3,
                                     :value4, :value5, :best, :average)
    end

    def check_competition_ongoing
      unless OnlineCompetition.find(params.require(:competition_id)).ongoing?
        raise ActiveRecord::RecordNotFound.new("Not Found")
      end
    end

    def check_competition_over
      # admin can always see results
      return if current_user&.can_manage_online_comps?
      # for others they need to wait until the comp is over
      unless OnlineCompetition.find(params.require(:competition_id)).over?
        raise ActiveRecord::RecordNotFound.new("Not Found")
      end
    end
end
