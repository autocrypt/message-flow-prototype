class Email < ApplicationRecord

  def self.to(recipient)
    where to: recipient
  end

  def self.from(sender)
    where from: sender
  end
end
