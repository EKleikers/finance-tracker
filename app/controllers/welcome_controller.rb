class WelcomeController < ActionController::Base
  def index
    render html: 'Welcome to the finance tracker!'
  end
end
