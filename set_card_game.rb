#!/usr/bin/env ruby

class SetCard
  attr_accessor :number
  attr_accessor :color
  attr_accessor :shape
  attr_accessor :shading
  
  NUMBERS  = [:one,:two,:three].freeze
  COLORS   = [:red,:green,:purple].freeze
  SHAPES   = [:diamond,:squiggle,:oval].freeze
  SHADINGS = [:solid,:striped,:open].freeze

  def initialize(number,color,shape,shading)
    @number  = number
    @color   = color
    @shape   = shape
    @shading = shading
  end

  def to_s
    return "[#{number}, #{color}, #{shape}, #{shading}]"
  end

  def self.generate_deck
    deck = []
    NUMBERS.each{|number| COLORS.each{|color| SHAPES.each{|shape| SHADINGS.each{|shading| deck.push(SetCard.new(number,color,shape,shading))}}}}
    return deck
  end

  def self.is_set?(cards)
    return false unless cards.length == 3

    unique_number_count  = [cards[0].number, cards[1].number, cards[2].number].uniq.count
    return false unless (unique_number_count == 3) || (unique_number_count == 1)

    unique_color_count   = [cards[0].color,  cards[1].color,  cards[2].color].uniq.count
    return false unless (unique_color_count == 3) || (unique_color_count == 1)

    unique_shape_count   = [cards[0].shape,  cards[1].shape,  cards[2].shape].uniq.count
    return false unless (unique_shape_count == 3) || (unique_shape_count == 1)

    unique_shading_count = [cards[0].shading, cards[1].shading, cards[2].shading].uniq.count
    return false unless (unique_shading_count == 3) || (unique_shading_count == 1)

    return true
  end

  def self.find_set(table_array)
    return [] unless table_array.size >= 3

    (0..table_array.size-1).to_a.each do |i|
      ((i+1)..table_array.size-1).to_a.each do |j|
        ((j+1)..table_array.size-1).to_a.each do |k|
          return [i,j,k] if is_set?( [ table_array[i], table_array[j], table_array[k] ] )
        end
      end
    end

    return []
  end

end # end of SetCard



deck = SetCard.generate_deck
deck.shuffle!
table = deck.shift(12)  # draw 12 cards
sets = []

# loop until the deck is empty and can't find any more sets on the table
while ( !(set_indexes = SetCard.find_set(table)).empty? || !deck.empty?)
  unless set_indexes.empty?
    sets.push( [ table[set_indexes[0]], table[set_indexes[1]], table[set_indexes[2]] ] )
    set_indexes.each {|set_index| table[set_index] = nil}
    table.compact!
  end

  # draw 3 more cards unless the deck is empty or found a set and there are 12 or more cards left on table
  table.concat(deck.shift(3)) unless ( deck.empty? || (!set_indexes.empty? && table.size >= 12) )
end

# print all found sets and stats
sets.each{|set| puts set; puts ''}
puts "sets found: #{sets.length}\ndeck size: #{deck.length}\ncards left on table: #{table.length}"
