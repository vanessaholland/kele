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
    headers = {
      headers: {
        :content_type => 'application/json',
        :authorization => @auth_token
      }
    }
    response = self.class.get(base_url('users/me'), headers)
    return @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    headers = {
      headers: {
        :content_type => 'application/json',
        :authorization => @auth_token
      }
    }
    response = self.class.get(base_url("mentors/#{mentor_id}/student_availability"), headers)
    return @mentor_avail = JSON.parse(response.body)
  end

  def get_messages(page = 1)
    response = self.class.get(base_url("message_threads"), values: {"page": page} , headers: { "content_type" => 'application/json', "authorization" => @auth_token })
    return @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text, prod)
    values = {
        "sender": sender,
        "recipient_id": recipient_id,
        "token": token,
        "subject": subject,
        "stripped-text": stripped_text
    }
    headers = {
        :content_type => 'application/json',
        :authorization => @auth_token
    }

    response = self.class.post(base_url("messages", prod), body: values, headers: headers)
    raise "There was an error submitting this message" if response.code != 200
    puts response
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment, enrollment_id, prod)
    headers = {
        :content_type => 'application/json',
        :authorization => @auth_token
    }

    values = {
        "assignment_branch": assignment_branch,
        "assignment_commit_link": assignment_commit_link,
        "checkpoint_id": checkpoint_id,
        "comment": comment,
        "enrollment_id": enrollment_id
    }

    response = self.class.post(base_url("checkpoint_submissions", prod), body: values, headers: headers)
    raise "There was a problem processing this submission" if response.code != 200
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
