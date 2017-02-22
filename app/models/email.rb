class Email < ApplicationRecord

  def initialize(params = {})
    if params[:subject]
      params[:source] = ApplicationMailer.new.mail(params).to_s
    end
    super
  end

end
