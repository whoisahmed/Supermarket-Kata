class Kata::Teller
  # adding offers
  # calculating receipt?
  # applying offers

  def initialize(catalog)
    @catalog = catalog
    @offers = {}
  end

  def add_special_offer(offer_type, product, argument)
    @offers[product] = Kata::Offer.new(offer_type, product, argument)
  end

  def checks_out_articles_from(the_cart)
    receipt = Kata::Receipt.new
    add_receipt_items(receipt, the_cart)
    apply_offers(receipt, the_cart)
    receipt
  end

  def apply_offers(receipt, cart)
    product_quantities = cart.product_quantities
    products = product_quantities.keys

    products.each do |p|
      next unless @offers.key?(p)

      offer = @offers[p]
      unit_price = @catalog.unit_price(p)
      quantity = product_quantities[p]
      quantity_as_int = quantity.to_i

      discount = calculate_discount(offer, p, quantity_as_int, unit_price)
     
      receipt.add_discount(discount) if discount
    end
  end

  def calculate_discount(offer, product, quantity, unit_price)
    case offer.offer_type
    when Kata::SpecialOfferType::THREE_FOR_TWO
      three_for_two_discount(product, quantity, unit_price)
    when Kata::SpecialOfferType::TWO_FOR_AMOUNT
      two_for_amount_discount(product, quantity, unit_price, offer.argument)
    when Kata::SpecialOfferType::TEN_PERCENT_DISCOUNT
      ten_percent_discount(product, quantity, unit_price, offer.argument)
    when Kata::SpecialOfferType::FIVE_FOR_AMOUNT
      five_for_amount_discount(product, quantity, unit_price, offer.argument)
    end
  end

  private

  def add_receipt_items(receipt, the_cart)
    the_cart.items.each do |pq|
      receipt_item = create_receipt_item(pq)
      receipt.add_receipt_item(receipt_item)
    end
  end

  def create_receipt_item(pq)
    price = @catalog.unit_price(pq.product)
    Kata::ReceiptItemFactory.call(
      product: pq.product,
      quantity: pq.quantity,
      price: price
    )
  end

  def three_for_two_discount(product, quantity, unit_price)
    return nil if quantity < 3
  
    number_of_x = quantity / 3
    discount_amount = quantity * unit_price - (number_of_x * 2 * unit_price + quantity % 3 * unit_price)
    Kata::Discount.new(product, "3 for 2", discount_amount)
  end

  def two_for_amount_discount(product, quantity, unit_price, argument)
    return nil if quantity < 2

    total = argument * (quantity / 2) + quantity % 2 * unit_price
    discount_amount = quantity * unit_price - total
    Kata::Discount.new(product, "2 for " + argument.to_s, discount_amount)
  end

  def ten_percent_discount(product, quantity, unit_price, argument)
    discount_amount = quantity * unit_price * argument / 100.0
    Kata::Discount.new(product, argument.to_s + "% off", discount_amount)
  end

  def five_for_amount_discount(product, quantity, unit_price, argument)
    return nil if quantity < 5

    number_of_x = quantity / 5
    discount_total = unit_price * quantity - (argument * number_of_x + quantity % 5 * unit_price)
    Kata::Discount.new(product, "5 for " + argument.to_s, discount_total)
  end
end
