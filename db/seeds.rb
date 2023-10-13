# require "csv"

# CSV.foreach('db/csv/users.csv', headers: true) do |row|
#   User.create!(
#     name: row['name'],
#     email: row['email'],
#     department: row['department'],
#     employee_number: row['employee_number'],
#     uid: row['uid'],
#     basic_time: row['basic_time'],
#     started_at: row['started_at'],
#     finished_at: row['finished_at'],
#     superior: row['superior'] == 'TRUE',
#     admin: row['admin'] == 'TRUE',
#     password: row['password']
#   )
# end