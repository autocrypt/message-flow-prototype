class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new]

  # GET /emails
  # GET /emails.json
  def index
    @inbox = Email.where(to: @user.name).all
    process_incoming(@inbox)
    @sent = Email.where(from: @user.name).all
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new from: (@user.name || '')
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new email_params_with_source

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_email
    @email = Email.find(params[:id])
  end

  def set_user
    @user = User.new params[:user_id]
  end

  def email_params_with_source
    email_params.merge source: mail_from_params.to_s
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_params
    params.require(:email).permit(:from, :to, :subject, :body)
  end

  def mail_from_params
    AutocryptMailer.mail_with_header(email_params)
  end

  def process_incoming(mails)
    autocrypt = Autocrypt.new(@user)
    mails.each do |mail|
      autocrypt.process_incoming mail.source
    end
  end
end
