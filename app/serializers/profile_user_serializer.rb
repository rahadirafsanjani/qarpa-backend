class ProfileUserSerializer
  include JSONAPI::Serializer
  attribute :id, :email, :name, :avatar_url

end
