class User
  include ActiveModel::Model

  attr_reader :name

  def initialize(name)
    @name = name
  end
  alias_method :id, :name
  alias_method :to_s, :name
  alias_method :to_param, :name

end
