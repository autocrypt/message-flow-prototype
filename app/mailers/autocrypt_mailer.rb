class AutocryptMailer < ApplicationMailer

  def mail_with_header(params = {})
    @params = params
    add_autocrypt_header
    params[:body] = try_to_encrypt
    mail params
  end

  protected

  attr_accessor :params

  def add_autocrypt_header
    if autocrypt.initialized?
      key, value = autocrypt.header.split(':')
      headers[key] = value
    end
  end

  def try_to_encrypt
    return params[:body] unless autocrypt.initialized?
    autocrypt.try_to_encrypt(params)
  end

  def autocrypt
    @autocrypt ||= Autocrypt.new params[:from]
  end

end
