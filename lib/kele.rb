require 'httparty'
require 'json'

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

    response = self.class.post(base_url('sessions'), options)
    raise "Invalid Email or Password" if response.code != 200
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(base_url('users/me'), headers: { "authorization" => @auth_token })
    return @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    return @mentor_avail = JSON.parse(response.body)
  end

  private

  def base_url(endpoint)

		return "https://www.bloc.io/api/v1/#{endpoint}"

	end
end
