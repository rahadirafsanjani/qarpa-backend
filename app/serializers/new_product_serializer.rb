class NewProductSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :quantity, :quantity_type, :category, :expire, :image_url, :supplier
  def supplier
    {
      supplier_id: self.object.supplier.id,
      supplier_name: self.object.supplier.name
    }
  end
end
