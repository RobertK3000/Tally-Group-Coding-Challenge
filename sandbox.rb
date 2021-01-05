@vs5_order_size = 7
# number of items ordered by customer

@vs5_pack_sizes = [3,5]
# possible pack sizes for item

@vs5_all_possible_packs_combinations = []
# array which houses all combinations of packs

def all_possible_pack_combinations
  # This method creates all possible combinations of n packs, until n >= the order qty.
  # This of course is overkill, however ensures that any possible combination of packs is captured.
  n = 1
  until n > @vs5_order_size
    combination_array = @vs5_pack_sizes.repeated_combination(n).to_a
    combination_array.each do |item|
      @vs5_all_possible_packs_combinations << item
    end
    n += 1
  end
end

def all_possible_pack_combinations_qty
  # This method creates new array of all possible qty totals for all pack combinations
  @vs5_all_possible_total_qty = @vs5_all_possible_packs_combinations.map { |combination| combination.sum }
end

def order_valid?
  @vs5_all_possible_total_qty.include?(@vs5_order_size)
end

# def permittable_pack_combinations
#   @permitable_combinations = @vs5_all_possible_packs_combinations.find_all { |combination| combination.sum == @vs5_order_size } 
# end


# calling the methods here
all_possible_pack_combinations
all_possible_pack_combinations_qty
order_valid?

p @vs5_all_possible_total_qty 
p order_valid?

# p permitable_combinations.sort_by { |combination| combination.count}
