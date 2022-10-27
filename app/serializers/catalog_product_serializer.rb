class CatalogProductSerializer
  include JSONAPI::Serializer
  attributes :name, :quantity, :quantity_type, :category, :expire, :image_url
end
