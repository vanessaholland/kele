require 'httparty'

class Kele
  include HTTParty
  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    options = {
      body: {
        email: email,
        password: password
      }
    }

    response = self.class.post("https://www.bloc.io/api/v1/sessions", options)
    raise "Invalid Email or Password" if response.code != 200
    @auth_token = response["auth_token"]
  end
end
