class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  def index
    @players = Player.all
  end

  # GET /players/1
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  def create
    @player = Player.new(player_params)

    if @player.save
      redirect_to @player, notice: 'Player was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /players/1
  def update
    if @player.update(player_params)
      redirect_to @player, notice: 'Player was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /players/1
  def destroy
    @player.destroy
    redirect_to players_url, notice: 'Player was successfully destroyed.'
  end

  def download
    send_data Player.csv_all, type: 'text/csv; charset=shift_jis', filename: "players.csv"
  end

  def new_upload
    @csv_errors = []
  end

  def create_upload
    players, errors = Player.import(params[:csv_file].read)
    errors = Player.merge(players)  unless errors.any?

    if errors.any?
      @csv_errors = errors
      render :new_upload
    else
      redirect_to players_url, notice: 'Player was successfully uploaded.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def player_params
      params.require(:player).permit(:name, :position, :no, :born)
    end
end
