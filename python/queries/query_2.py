from tkinter import *
from tkinter.ttk import Combobox
import mysql.connector



def open_results_window(response):
    # Створення нового вікна
    results_window = Toplevel()
    results_window.title("Результат запиту")

    # Віджет Text для виведення результатів
    text = Text(results_window, width=50, height=10)
    text.pack()

    # Додавання результатів до віджету Text
    for row in response:
            text.insert(END, str(row) + "\n")  # Додавання рядка до віджету Text

    # Кнопка для повернення до початкового вікна
    back_button = Button(results_window, text="Повернутися", command=results_window.destroy)
    back_button.pack()



def query2(staff_category, med_type, med_name):
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

    try:
        print("Отримати перелік і загальне число лікарів зазначеного профілю для конкретного медичного закладу, лікарні або всіх медичних установ міста. ")
        
        if med_type == "Лікарня":
            query1 = f"""SELECT s.staff_id, s.name, s.category, h.hospital_name
                        FROM staff s
                        INNER JOIN staff_hospital_contracts shc ON s.staff_id = shc.staff_id
                        INNER JOIN hospitals h ON shc.hospital_id = h.hospital_id
                        WHERE h.hospital_name = '{med_name}' AND s.category = '{staff_category}';"""
            query2 = f"""SELECT COUNT(s.staff_id)
                        FROM staff s
                        INNER JOIN staff_hospital_contracts shc ON s.staff_id = shc.staff_id
                        INNER JOIN hospitals h ON shc.hospital_id = h.hospital_id
                        WHERE h.hospital_name = '{med_name}' AND s.category = '{staff_category}';"""
        elif med_type == "Поліклініка":
            query1 = f"""SELECT s.staff_id, s.name, s.category, p.polyclinic_name
                        FROM staff s
                        INNER JOIN staff_polyclinic_contracts spc ON s.staff_id = spc.staff_id
                        INNER JOIN polyclinics p ON spc.polyclinic_id = p.polyclinic_id
                        WHERE p.polyclinic_name = '{med_name}' AND s.category = '{staff_category}';"""
            query2 = f"""SELECT COUNT(s.staff_id)
                        FROM staff s
                        INNER JOIN staff_polyclinic_contracts spc ON s.staff_id = spc.staff_id
                        INNER JOIN polyclinics p ON spc.polyclinic_id = p.polyclinic_id
                        WHERE p.polyclinic_name = '{med_name}' AND s.category = '{staff_category}';"""
        elif med_type == "Всі":
            query1 = f"""SELECT s.staff_id, s.name, s.category, spc.polyclinic_id, shc.hospital_id 
                        FROM staff s
                        LEFT JOIN staff_polyclinic_contracts spc ON s.staff_id = spc.staff_id
                        LEFT JOIN staff_hospital_contracts shc ON s.staff_id = shc.staff_id
                        WHERE s.category = '{staff_category}';"""
            query2 = f"""SELECT COUNT(s.staff_id)
                        FROM staff s
                        LEFT JOIN staff_polyclinic_contracts spc ON s.staff_id = spc.staff_id
                        LEFT JOIN staff_hospital_contracts shc ON s.staff_id = shc.staff_id
                        WHERE s.category = '{staff_category}';"""

        cursor = connection.cursor() 
        response = []
        cursor.execute(query1)
        response += cursor.fetchall()
        print(response)
        cursor.execute(query2)
        response += cursor.fetchall()
        print(response)
        connection.close()
        return response

    except mysql.connector.Error as e:
        print(e)
        connection.close()



def button_click_2() -> None:
    # Створення нового вікна
    input_window = Toplevel()
    input_window.title("Введіть дані")
    input_window.geometry("800x500")
    # input_window.geometry("1536x864")  # розмір всього екрану

    # Віджети Entry для вводу типу медичного закладу та назви медичного закладу
    input_frame = LabelFrame(input_window, text="Введіть пошукові дані", font=("Arial", 14))  # Збільшення розміру шрифту
    input_frame.pack(padx=10, pady=10)

    connection = mysql.connector.connect(
        host='127.0.0.1',
        user='root',
        password='ROOT',
        database='medical_organizations'
    )

    query = "SELECT DISTINCT category FROM staff"
    cursor = connection.cursor() 
    cursor.execute(query)
    response = cursor.fetchall()

    vars = [el[0] for el in response]
    print(vars)

    doc_label = Label(input_frame, text="Спеціальність обслуги:", font=("Arial", 12))  # Збільшення розміру шрифту
    doc_label.grid(row=0, column=0, sticky=W)
    doc_entry = Combobox(input_frame, values=vars, font=("Arial", 12))  # Збільшення розміру шрифту
    doc_entry.grid(row=0, column=1)

    type_label = Label(input_frame, text="Тип закладу:", font=("Arial", 12))  # Збільшення розміру шрифту
    type_label.grid(row=1, column=0, sticky=W)
    type_entry = Entry(input_frame, font=("Arial", 12))  # Збільшення розміру шрифту
    type_entry.grid(row=1, column=1)

    name_label = Label(input_frame, text="Назва закладу:", font=("Arial", 12))  # Збільшення розміру шрифту
    name_label.grid(row=2, column=0, sticky=W)
    name_entry = Entry(input_frame, font=("Arial", 12))  # Збільшення розміру шрифту
    name_entry.grid(row=2, column=1)

    def foo():
        staff_category = doc_entry.get()
        med_type = type_entry.get()
        med_name = name_entry.get()
        response = query2(staff_category, med_type, med_name)
        open_results_window(response)

    button = Button(input_window, text="Виконати", command=lambda: foo(), font=("Arial", 12))  # Збільшення розміру шрифту
    button.pack()

