class OnlineCompetitionsController < ApplicationController
  PUBLIC_ACTIONS = [:index, :show].freeze
  before_action :authenticate_user!, except: PUBLIC_ACTIONS
  before_action :redirect_unless_can_manage_online_competitions!, except: PUBLIC_ACTIONS
  before_action :set_online_competition, only: [:show, :edit, :update, :destroy, :admin]

  # GET /online_competitions
  # GET /online_competitions.json
  def index
    @online_competitions = OnlineCompetition.by_start_date
    unless current_user&.can_manage_online_comps?
      @online_competitions = @online_competitions.visible
    end
  end

  def admin
    @force_show_results = true
    render :show
  end

  def show
  end

  def new
    @online_competition = OnlineCompetition.new
  end

  def edit
  end

  def create
    @online_competition = OnlineCompetition.new(online_competition_params)

    if @online_competition.save
      redirect_to @online_competition, flash: {
        success: 'Online competition was successfully created.'
      }
    else
      render :new
    end
  end

  # PATCH/PUT /online_competitions/1
  # PATCH/PUT /online_competitions/1.json
  def update
    if @online_competition.update(online_competition_params)
      redirect_to @online_competition, flash: {
        success: 'Online competition was successfully updated.'
      }
    else
      render :edit
    end
  end

  # DELETE /online_competitions/1
  # DELETE /online_competitions/1.json
  def destroy
    @online_competition.destroy
    redirect_to online_competitions_url, flash: {
      success: 'Online competition was successfully destroyed.'
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_online_competition
      @online_competition = OnlineCompetition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def online_competition_params
      params.require(:online_competition).permit(:name, :start_date, :end_date, :visible)
    end
end
