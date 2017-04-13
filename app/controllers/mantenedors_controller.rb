class MantenedorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mantenedor, only: [:show, :edit, :update, :destroy]

  # GET /mantenedors
  # GET /mantenedors.json
  def index
    @mantenedors = Mantenedor.all
  end

  # GET /mantenedors/1
  # GET /mantenedors/1.json
  def show
  end

  # GET /mantenedors/new
  def new
    @mantenedor = Mantenedor.new
  end

  # GET /mantenedors/1/edit
  def edit
  end

  # POST /mantenedors
  # POST /mantenedors.json
  def create
    @mantenedor = Mantenedor.new(mantenedor_params)

    respond_to do |format|
      if @mantenedor.save
        format.html { redirect_to @mantenedor, notice: 'Mantenedor was successfully created.' }
        format.json { render action: 'show', status: :created, location: @mantenedor }
      else
        format.html { render action: 'new' }
        format.json { render json: @mantenedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mantenedors/1
  # PATCH/PUT /mantenedors/1.json
  def update
    respond_to do |format|
      if @mantenedor.update(mantenedor_params)
        format.html { redirect_to @mantenedor, notice: 'Mantenedor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mantenedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mantenedors/1
  # DELETE /mantenedors/1.json
  def destroy
    @mantenedor.destroy
    respond_to do |format|
      format.html { redirect_to mantenedors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mantenedor
      @mantenedor = Mantenedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mantenedor_params
      params.require(:mantenedor).permit(:tipo, :valor, :misc, :codigo)
    end
end
