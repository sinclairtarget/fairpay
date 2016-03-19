# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# groups
acme = Group.create(name: "Acme Co. Employees", invitations_count: 7)
zeta = Group.create(name: "Zeta Inc. Paralegals", invitations_count: 2)
tiny = Group.create(name: "Tiny Co.", invitations_count: 2)

# users
anne = User.create(email: "anne@test.com", password: "p@sswrd")
bob = User.create(email: "bob@test.com", password: "p@sswrd")
cindy = User.create(email: "cindy@test.com", password: "p@sswrd")
dave = User.create(email: "dave@test.com", password: "p@sswrd")
ethan = User.create(email: "ethan@test.com", password: "p@sswrd")
fred = User.create(email: "fred@test.com", password: "p@sswrd")
greg = User.create(email: "greg@test.com", password: "p@sswrd")
heather = User.create(email: "heather@test.com", password: "p@sswrd")
ingrid = User.create(email: "ingrid@test.com", password: "p@sswrd")
john = User.create(email: "john@test.com", password: "p@sswrd")

dev = User.create(email: "dev@test.com",
                  password: "p@sswrd",
                  verified: true)

# salaries
comp = "Compliance Officer"
sales = "Sales Representative"
manager = "Sales Manager"
paralegal = "Paralegal"
s_paralegal = "Senior Paralegal"

Salary.create(user: anne, group: acme, title: comp, annual_pay: 66000)
Salary.create(user: bob, group: acme, title: sales, annual_pay: 45000)
Salary.create(user: cindy, group: acme, title: sales, annual_pay: 42000)
Salary.create(user: dave, group: acme, title: manager, annual_pay: 84000)
Salary.create(user: ethan, group: acme, title: manager, annual_pay: 98000)
Salary.create(user: fred, group: acme, title: sales, annual_pay: 46000)
Salary.create(user: greg, group: acme, title: sales, annual_pay: 45000)

Salary.create(user: heather, group: zeta, title: paralegal, annual_pay: 55000)
Salary.create(user: ingrid, group: zeta, title: paralegal, annual_pay: 55000)
Salary.create(user: john, group: zeta, title: s_paralegal, annual_pay: 64000)

Salary.create(user: dev, group: acme, title: "Developer", annual_pay: 95000)
Salary.create(user: dev, group: zeta, title: "Developer", annual_pay: 87000)
Salary.create(user: dev, group: tiny, title: "Developer", annual_pay: 95000)
