class ReportingController < ApplicationController

  def dashboard
    @vehicles = Vehicle.all
    @earnings = calculate_earnings
    @fixed_monthly_costs = fixed_monthly_costs
    @monthly_breakdown = monthly_breakdown
  end

  protected

  def calculate_earnings
    Money.new(Reservation.sum(:expected_earnings_cents))
  end

  def total_tolls
    Money.new(Tolls.sum(:amount_cents))
  end

  def total_reimbursements
    Money.new(Reservation.sum(:reimbursements_cents))
  end

  def fixed_monthly_costs
    cost_cents = [
      Vehicle.sum(:loan_payment_cents),
      Vehicle.sum(:parking_payment_cents),
      Vehicle.sum(:insurance_payment_cents)
    ].sum
    Money.new(cost_cents)
  end

  def monthly_breakdown
    year = DateTime.new(2016)
    range = year.beginning_of_year..year.end_of_year
    month_names = range.to_a.map(&:beginning_of_month).uniq.map { |m| Date::MONTHNAMES[m.month] }

    @monthly_breakdown = Hash.new
    month_names.each do |month|
      reservations = monthly_reservations(month)
      @monthly_breakdown[month] = {
        reservations: reservations,
        earnings: Money.new(reservations.sum(:expected_earnings_cents)),
        extras: Money.new(monthly_extras(reservations)),
        expenses: Money.new(monthly_expenses(month))
      }
    end
    @monthly_breakdown
  end

  def month_range(month)
    start_of_month = DateTime.parse("#{month}, 2016").beginning_of_month
    end_of_month = DateTime.parse("#{month}, 2016").end_of_month
    month_range = start_of_month..end_of_month
  end

  def monthly_reservations(month)
    Reservation.where(end_date: month_range(month))
  end

  def monthly_extras(reservations)
    tolls = reservations.includes(:vehicle).map { |r| r.tolls.sum(:amount_cents) }.sum
    reimbursements = reservations.sum(:reimbursements_cents)
    Money.new(reimbursements - tolls)
  end

  def monthly_expenses(month)
    Expense.where(date: month_range(month)).sum(:amount_cents)
  end

end
