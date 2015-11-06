#!/usr/bin/env ruby
require 'date'

class LineOfCredit
  def initialize(apr, limit, date=Date.today)
    @ledger = []
    @ledger << [date, limit, apr, 0, false]
  end

  def entry(date)
    @ledger.reverse.find { |entry| entry[0] <= date }
  end

  def last_interest_charge
    @ledger.reverse.find { |entry| entry[4]} || @ledger[0]
  end

  def apr(date=Date.today)
    entry(date)[2]
  end

  def limit(date=Date.today)
    entry(date)[1]
  end

  def balance(date=Date.today)
    entry(date)[3]
  end

  def available(date=Date.today)
    limit - entry(date)[3]
  end

  def draw(amt, date=Date.today)
    raise "Drawing #{amt} would excede current limit #{limit(date)}. Avalaible credit is #{available(date)}." unless amt <= available
    @ledger << [date, limit, apr, balance(date) + amt, false]
    entry(date)
  end

  def pay(amt, date=Date.today)
    @ledger << [date, limit, apr, balance - amt, false]
    entry(date)
  end

  def interest(date=Date.today)
    (last_interest_charge[0]..date-1).map { |d| balance(d) * apr(d) / 365  }.inject(:+)
  end

  def payoff(date=Date.today)
    interest(date) + balance(date)
  end

  def close_month(date=Date.today)
    @ledger << [date, limit, apr, balance(date) + interest, true]
    entry(date)
  end
end

p "Scenario 1"
loc = LineOfCredit.new 0.35, 1000, Date.today-30
p loc
p loc.draw 500, Date.today-30
p loc.payoff

p "Scenario 2"
loc = LineOfCredit.new 0.35, 1000, Date.today-30
p loc
p loc.draw 500, Date.today-30
p loc.pay 200, Date.today-15
p loc.draw 100, Date.today-5
p loc.payoff

p "New Scenario"
loc = LineOfCredit.new 0.35, 1000, Date.today-60
p loc
p loc.draw 500, Date.today-60
p loc.close_month Date.today - 30
p loc.pay 100, Date.today-30
p loc.draw 500, Date.today-30
p loc.pay 200, Date.today-15
p loc.draw 100, Date.today-5
p loc.payoff
