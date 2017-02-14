module Roadmap

  def get_roadmap(roadmap_id)
    response = self.class.get(base_url("/roadmaps/#{roadmap_id}"), headers: {  "content_type" => 'application/json', "authorization" => @auth_token })
    return @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(base_url("/checkpoints/#{checkpoint_id}"), headers: {  "content_type" => 'application/json', "authorization" => @auth_token })
    return @checkpoint = JSON.parse(response.body)
  end

  private

  def base_url(endpoint)
    return "https://www.bloc.io/api/v1/#{endpoint}"
  end

end
