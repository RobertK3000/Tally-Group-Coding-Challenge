require 'pry'

VS5 = { 3 => 6.99, 5 => 8.99 }
MB11 = { 2 => 9.95, 5 => 16.95, 8 => 24.99 }
CF = { 3 => 5.95, 5 => 9.95, 9 => 16.99 }

p "How many VS5 would you like to order?"
@qty = gets.chomp.to_i

@order_size = @qty
# ^ number of items ordered by customer.

@pack_sizes = [3,5]
# @pack_sizes = [2,5,8]
# @pack_sizes = [3,5,9]
# ^ possible pack sizes for VS5, MB11, and CF resepectively.

@all_possible_packs_combinations = []
# ^ array which houses all combinations of packs.

def all_possible_pack_combinations
# ^ This method creates all possible combinations of n packs, until n >= the order qty.
# ^ This of course is overkill, however ensures that any possible combination of packs is captured.
  n = 1
  until n > @order_size
    combination_array = @pack_sizes.repeated_combination(n).to_a
    combination_array.each do |item|
      @all_possible_packs_combinations << item
    end
    n += 1
  end
end

def permittable_pack_combinations
# ^ Finds all pack combinations which satisfy order qty.
  @permittable_combinations = @all_possible_packs_combinations.find_all { |combination| combination.sum == @order_size } 
end

def order_valid?
# ^ Checks if order qty can be created from available pack sizes.
  if @permittable_combinations.empty? 
    false
  else
    true
  end
end

def most_efficient_pack_combinations
# ^ This method finds the order combinations with the least amounts of packs.
  unless @permittable_combinations.nil?
    @package_count = @permittable_combinations.map do |combination|
      combination.count
    end
  end
  # ^ Creates new array from permittable combinations where each element is the total number of packs for given order combination.
  unless @package_count.empty?
    @min_packs_count = @package_count.group_by(&:itself).min.first
  end
  # ^ Determines how many packs are in most efficient pack combination/s.
  @most_efficient_packs = @permittable_combinations.find_all { |combination| combination.count == @min_packs_count } 
  # ^ Finds the most efficient pack combination/s.
end

def calculate_total_price(order)
# ^ Calculates total price for any valid order.
  order.map { |qty| VS5[qty] }.sum
end

def cheapest_price(combinations)
# ^ Finds the cheapest price amongst different minimum pack combinations.
  prices = []
  combinations.each do |combination|
    prices << calculate_total_price(combination)
  end
  @cheapest_price = prices.min
end

def winning_pack
# ^ Finds the cheapest pack combination out of the minimum pack combinations.
  @winning_pack = @most_efficient_packs.find {|pack| calculate_total_price(pack) == @cheapest_price }
end

def cost_breakdown
# ^ Detailed cost breakdown of winning pack.
  unless @winning_pack.nil?
    @winning_pack.group_by(&:itself).map { |a, b| "#{b.size} x #{a} $#{VS5[a]} " }
  end
end

all_possible_pack_combinations
permittable_pack_combinations
most_efficient_pack_combinations
order_valid?

if order_valid? 
  p "This order is valid" 
  p "These are all the possible combinations to make up the order #{@permittable_combinations}"
  p "The total cost of your order is #{cheapest_price(@most_efficient_packs)}"
  winning_pack
  unless cost_breakdown.nil?
    p "The breakdown for your order is #{cost_breakdown.join}"
  end
else
  p "This order is not valid. Please choose a different amount."
end