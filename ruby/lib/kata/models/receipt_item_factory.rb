class Kata::ReceiptItemFactory
  
  def self.call(product:, quantity:, price:)
    total_price = quantity * price

    Kata::ReceiptItem.new(product, quantity, price, total_price)
  end
end
