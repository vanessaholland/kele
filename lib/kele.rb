require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele
  include HTTParty
  include Roadmap

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
    response = self.class.get(base_url("mentors/#{mentor_id}/student_availability"), headers: { "content_type" => 'application/json', "authorization" => @auth_token })
    return @mentor_avail = JSON.parse(response.body)
  end

  def get_messages(page = 1)
    response = self.class.get(base_url("message_threads"), values: {"page": page}, headers: { "content_type" => 'application/json', "authorization" => @auth_token })
    return @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text, prod)
    values = '{
        "sender": sender,
        "recipient_id": recipient_id,
        "token": token,
        "subject": subject,
        "stripped-text": stripped_text
        }'
        response = self.class.post(base_url("messages", prod), body: values, headers: { "authorization" => @auth_token })
        puts response
  end

  private

  def base_url(endpoint, prod = true)
    if prod
      return "https://www.bloc.io/api/v1/#{endpoint}"
    else
      return "https://private-anon-bfb3dd2996-blocapi.apiary-mock.com/api/v1/#{endpoint}"
    end
	end
end
