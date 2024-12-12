class Kata::Receipt

  def initialize
    @items = []
    @discounts = []
  end

  def total_price
    total = @items.sum(&:total_price)
    discount = @discounts.sum(&:discount_amount)

    total - discount
  end

  def add_product(product, quantity, price, total_price)
    @items << Kata::ReceiptItem.new(product, quantity, price, total_price)
    nil
  end

  def items
    Array.new @items
  end

  def add_discount(discount)
    @discounts << discount
    nil
  end

  def discounts
    Array.new @discounts
  end

end
