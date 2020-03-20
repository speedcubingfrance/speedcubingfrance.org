class OnlineCompetitionsController < ApplicationController
  PUBLIC_ACTIONS = [:index, :show].freeze
  before_action :authenticate_user!, except: PUBLIC_ACTIONS
  before_action :redirect_unless_can_manage_online_competitions!, except: PUBLIC_ACTIONS
  before_action :set_online_competition, only: [:show, :edit, :update, :destroy]

  # GET /online_competitions
  # GET /online_competitions.json
  def index
    @online_competitions = OnlineCompetition.by_start_date
    unless current_user&.can_manage_online_comps?
      @online_competitions = @online_competitions.visible
    end
  end

  # GET /online_competitions/1
  # GET /online_competitions/1.json
  def show
  end

  # GET /online_competitions/new
  def new
    @online_competition = OnlineCompetition.new
  end

  # GET /online_competitions/1/edit
  def edit
  end

  # POST /online_competitions
  # POST /online_competitions.json
  def create
    @online_competition = OnlineCompetition.new(online_competition_params)

    respond_to do |format|
      if @online_competition.save
        format.html { redirect_to @online_competition, notice: 'Online competition was successfully created.' }
        format.json { render :show, status: :created, location: @online_competition }
      else
        format.html { render :new }
        format.json { render json: @online_competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /online_competitions/1
  # PATCH/PUT /online_competitions/1.json
  def update
    respond_to do |format|
      if @online_competition.update(online_competition_params)
        format.html { redirect_to @online_competition, notice: 'Online competition was successfully updated.' }
        format.json { render :show, status: :ok, location: @online_competition }
      else
        format.html { render :edit }
        format.json { render json: @online_competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /online_competitions/1
  # DELETE /online_competitions/1.json
  def destroy
    @online_competition.destroy
    respond_to do |format|
      format.html { redirect_to online_competitions_url, notice: 'Online competition was successfully destroyed.' }
      format.json { head :no_content }
    end
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
