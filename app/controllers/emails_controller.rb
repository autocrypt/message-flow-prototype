class EmailsController < ApplicationController
  before_action :set_user
  before_action :set_autocrypt
  before_action :set_email, only: [:show]

  # GET /emails
  # GET /emails.json
  def index
    @inbox = Email.to(@user.name)
    process_incoming(@inbox)
    @sent = Email.from(@user.name)
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    @decrypted = @autocrypt.decrypt(@email)
    @reply_params = {
      to: @email.from,
      subject: 'Re: ' + @email.subject,
      body: (@decrypted || @email.body).gsub(/^/, '> ')
    }
  end

  # GET /emails/new
  def new
    @email = Email.new from: (@user.name || ''),
      to: params[:to],
      subject: params[:subject],
      body: params[:body]
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = @autocrypt.prepare_outgoing(Email.new email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to user_emails_path(@user), notice: 'Email was successfully send.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
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
    @user = User.new params[:user_id].downcase
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_params
    params.require(:email).
      permit(:to, :subject, :body).
      merge(from: @user.to_s.downcase).tap do |params|
        params[:to] = params[:to].downcase
      end
  end

  def process_incoming(inbox)
    inbox.each do |mail|
      @autocrypt.process_incoming mail
    end
  end

  def set_autocrypt
    @autocrypt = Autocrypt.new(@user)
  end
end
