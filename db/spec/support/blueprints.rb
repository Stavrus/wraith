require 'machinist/active_record'

User.blueprint do
  uid   { 'uid' }
  role  { Role.find_by_name 'Normal' }
  email { 'email' }
end