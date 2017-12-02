class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    if user_signed_in?
      @records = Record.where('user_id=?', current_user.id)
    else
      @records=[]
    end
  end

  # GET /records/1
  # GET /records/1.json
  # def show
  # end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  # def edit
  # end

  # POST /records
  # POST /records.json
  def create
    if user_signed_in?
      @record = Record.new(record_params)
      @record.user=current_user
      @prev=Record.last
      if !@prev.nil?
        if @record.description=="Debit"
          @record.balance=@prev.balance-@record.amount
        elsif @record.description=="Credit"
          @record.balance=@prev.balance+@record.amount
        end
      else
        if @record.description=="Debit"
          @record.balance=-@record.amount
        elsif @record.description=="Credit"
          @record.balance=@record.amount
        end
      end
      respond_to do |format|
        if @record.save
          format.html { redirect_to records_path, notice: 'Record was successfully created.' }
          format.json { render :show, status: :created, location: @record }
        else
          format.html { render :new }
          format.json { render json: @record.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to records_path, notice: 'You must first Sign in!'
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  # def update
  #   if @record.user==current_user
  #     respond_to do |format|
  #       if @record.update(record_params)
  #         format.html { redirect_to @record, notice: 'Record was successfully updated.' }
  #         format.json { render :show, status: :ok, location: @record }
  #       else
  #         format.html { render :edit }
  #         format.json { render json: @record.errors, status: :unprocessable_entity }
  #       end
  #     end
  #   else
  #     redirect_to records_path, notice: 'You are not allowed to edit this Record'
  #   end
  # end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    if @record.user==current_user
      @record.destroy
      respond_to do |format|
        format.html { redirect_to records_path, notice: 'Record was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to records_path, notice: 'You are not allowed to delete this Record'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:description, :amount, :balance, :user)
    end
end
