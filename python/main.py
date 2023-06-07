from tkinter import *
from queries.query_1 import *
from queries.query_2 import *
from queries.query_3 import *
from queries.query_4 import *
from queries.query_5 import *
from queries.query_6 import *
from queries.query_7 import *
from queries.query_8 import *
from queries.query_9 import *
from queries.query_10 import *
from queries.query_11 import *
from queries.query_12 import *
from queries.query_13 import *
from queries.query_14 import *


connection = mysql.connector.connect(
    host='127.0.0.1',
    user='root',
    password='ROOT',
    database='medical_organizations'
)
if connection.is_connected():
    print('Connected to MySQL database')
else:
    print('Disconnected!')
    exit()





root_window = Tk()
root_window.title("AIC медичних організацій міста")
root_window.geometry(f"800x500")

# button_names = ["Query 1", "Query 2", "Query 3", "Query 4", "Query 5", "Query 6", 
#                 "Query 7", "Query 8", "Query 9", "Query 10", "Query 11", "Query 12", 
#                 "Query 13", "Query 14"]
# commands = [button_click_1, button_click_2, button_click_3, button_click_4, button_click_5, button_click_6, 
#             button_click_7, button_click_8, button_click_9, button_click_10, button_click_11, button_click_12, 
#             button_click_13, button_click_14]

button1 = Button(root_window, text="Query 1", command=lambda: button_click_1(connection), font=("Arial", 12))
button1.pack()


root_window.mainloop()

connection.close()