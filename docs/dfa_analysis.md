Переменная: log_entry

Def: строка 2 (log_entry = "Start processing")
Def: строка 8 (log_entry = "Transaction finished with status: " + status)
Use: строка 10 (file.write(log_entry))

Переменная: status

· Def: строка 4 (status = "approved") — только внутри ветки if amount > 0
· Use: строка 8 (конкатенация)
· Use: строка 11 (return status)

Переменная: balance

· Def: строка 5 (balance = get_balance(user_id))
· Use: строка 6 (new_balance = balance - amount)

Переменная: new_balance

· Def: строка 6 (new_balance = balance - amount)
· Use: строка 7 (update_balance(user_id, new_balance))

Переменная: file

· Def: строка 9 (file = open("audit_log.txt", "w"))
· Use: строка 10 (file.write(log_entry))
