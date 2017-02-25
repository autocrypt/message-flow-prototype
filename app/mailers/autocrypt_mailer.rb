class AutocryptMailer < ApplicationMailer

  def mail_with_header(params)
    add_autocrypt_header params
    mail params
  end

  protected

  def add_autocrypt_header(params)
    autocrypt = Autocrypt.new params[:from]
    if autocrypt.initialized?
      key, value = autocrypt.header.split(':')
      headers[key] = value
    end
  end
end
