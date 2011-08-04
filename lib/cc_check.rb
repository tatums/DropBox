#!/usr/local/bin/ruby

class CreditCard

  TYPES = {
    :visa => {:length => [13, 16], :start => [4]},
    :discover => {:length => [16], :start => [6011]},
    :mastercard => {:length => [16], :start => 51..55},
    :amex => {:length => [15], :start => [34, 37]}
  }

  def initialize(number)
    @number = number.gsub(/\D/,'')
  end

  def valid?
    adjusted_numbers = ''
    @number.reverse.split('').each_with_index do |x, i|
      adjusted_numbers << (i % 2 == 0 ? x : (x.to_i * 2).to_s)
    end
    adjusted_numbers.split('').inject(0) {|sum, x| sum += x.to_i} % 10 == 0
  end

  def card_type
    TYPES.each do |type, criteria|
      if criteria[:start].any? {|n| @number.match(Regexp.compile('^'+n.to_s))}
        if criteria[:length].include? @number.length
          return type
        end
      end
    end
    :unknown
  end

end

if __FILE__ == $0
  test_card = CreditCard.new(ARGV.join(''))
  puts "Card type: #{test_card.card_type}"
  print test_card.valid? ? "Passes" : "Fails"
  puts " the Luhn algorithm."
end
