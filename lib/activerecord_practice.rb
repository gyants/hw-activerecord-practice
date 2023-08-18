require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    Customer.where(first: 'Candice')

  end
  def self.with_valid_email
    Customer.where("email LIKE ?", "%@%")
  end
  def self.with_dot_org_email
    Customer.where("email LIKE ?","%.org")
  end
  def self.with_invalid_email
    Customer.where.not("email LIKE ?", "%@%")
  end
  def self.with_blank_email
    Customer.where("email = '' OR email IS NULL")
  end
  def self.born_before_1980
    Customer.where("birthdate < ?","1980-01-01")
  end 
  def self.with_valid_email_and_born_before_1980
    Customer.where("birthdate < ? AND email LIKE ?","1980-01-01","%@%")
  end
  def self.last_names_starting_with_b
    Customer.where("last LIKE ?","B%").order(birthdate: :asc)
  end
  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end
  def self.update_gussie_murray_birthdate
    Customer.where(first: 'Gussie', last: "Murray").update(birthdate: "2004-02-08")
  end
  def self.change_all_invalid_emails_to_blank
    invalid_email = with_invalid_email
    invalid_email.update(email: '')
  end
  def self.delete_meggie_herman
    Customer.where(first:'Meggie', last:'Herman').delete_all
  end
  def self.delete_everyone_born_before_1978
    Customer.where("birthdate <= ?","1977-12-31").delete_all
  end
end
