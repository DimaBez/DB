from tkinter import *
from tkinter.ttk import Combobox
import mysql.connector



def open_results_window(result, number):
    results_window = Toplevel()
    results_window.title("Результат запиту")
    results_window.geometry("800x500")
    
    input_frame = LabelFrame(results_window, text="Результат", font=("Arial", 14)) 
    input_frame.pack(padx=10, pady=10)

    table_label = Label(input_frame, text="Таблиця:", font=("Arial", 12)) 
    table_label.grid(row=0, column=0, sticky=W)
    table = Text(input_frame, width=50, height=10)
    table.grid(row=0, column=1)

    count_label = Label(input_frame, text="Загальна кількість:", font=("Arial", 12)) 
    count_label.grid(row=1, column=0, sticky=W)
    count = Text(input_frame, width=50, height=1)
    count.grid(row=1, column=1)

    for row in result:
            print(row)
            table.insert(END, str(row) + "\n")
    count.insert(END, str(number))



def query1(connection: mysql.connector.MySQLConnection, 
           doc_category, med_type, med_name):
    print("Отримати перелік і загальне число лікарів зазначеного профілю для конкретного медичного закладу, лікарні або всіх медичних установ міста. ")

    if med_type == "Лікарня":
        query_1 = f"""SELECT SQL_CALC_FOUND_ROWS d.doctor_id, d.name, d.category, h.hospital_name
                FROM doctors d
                INNER JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
                INNER JOIN hospitals h ON dhc.hospital_id = h.hospital_id
                WHERE h.hospital_name = '{med_name}' AND d.category = '{doc_category}';"""
    elif med_type == "Поліклініка":
        query_1 = f"""SELECT SQL_CALC_FOUND_ROWS d.doctor_id, d.name, d.category, p.polyclinic_name
                    FROM doctors d
                    INNER JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
                    INNER JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
                    WHERE p.polyclinic_name = '{med_name}' AND d.category = '{doc_category}'"""
    elif med_type == "Всі":
        query_1 = f"""SELECT SQL_CALC_FOUND_ROWS d.doctor_id, d.name, d.category, dpc.polyclinic_id, dhc.hospital_id 
                    FROM doctors d
                    LEFT JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
                    LEFT JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
                    WHERE d.category = '{doc_category}';"""
    query_2 = "SELECT found_rows();"

    cursor = connection.cursor() 
    cursor.execute(query_1)
    response1 = cursor.fetchall()
    cursor.execute(query_2)
    response2 = cursor.fetchall()
    return response1, response2[0][0]



def button_click_1(connection: mysql.connector.MySQLConnection) -> None:
    cursor = connection.cursor() 

    input_window = Toplevel()
    input_window.title("Введіть дані")
    input_window.geometry("800x500")


    query = "SELECT DISTINCT category FROM doctors"
    cursor.execute(query)
    response = cursor.fetchall()
    doc_category_vars = [el[0] for el in response]

    query = "SELECT DISTINCT name as name FROM hospitals"
    cursor.execute(query)
    response = cursor.fetchall()
    h_name_vars = [el[0] for el in response]

    query = "SELECT DISTINCT name as name FROM polyclinics"
    cursor.execute(query)
    response = cursor.fetchall()
    p_name_vars = [el[0] for el in response]


    input_frame = LabelFrame(input_window, text="Введіть пошукові дані", font=("Arial", 14)) 
    input_frame.pack(padx=10, pady=10)

    doc_label = Label(input_frame, text="Спеціальність лікаря:", font=("Arial", 12)) 
    doc_label.grid(row=0, column=0, sticky=W)
    doc_entry = Combobox(input_frame, values=doc_category_vars, font=("Arial", 12))
    doc_entry.grid(row=0, column=1)

    h_label = Label(input_frame, text="Назва лікарні:", font=("Arial", 12)) 
    h_label.grid(row=1, column=0, sticky=W)
    h_entry = Combobox(input_frame, values=h_name_vars, font=("Arial", 12))
    h_entry.grid(row=1, column=1)

    p_label = Label(input_frame, text="Назва поліклініки:", font=("Arial", 12)) 
    p_label.grid(row=2, column=0, sticky=W)
    p_entry = Combobox(input_frame, values=p_name_vars, font=("Arial", 12))
    p_entry.grid(row=2, column=1)

    def foo():
        doc_category = doc_entry.get()
        h_name = h_entry.get()
        p_name = p_entry.get()
 
        if h_name != '':
            q = f"""SELECT d.doctor_id, d.name, d.category, h.name
            FROM doctors d
            INNER JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
            INNER JOIN hospitals h ON dhc.hospital_id = h.hospital_id
            WHERE h.name = '{h_name}' AND d.category = '{doc_category}';"""
        elif p_name != '':
            q = f"""SELECT d.doctor_id, d.name, d.category, p.name
            FROM doctors d
            INNER JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
            INNER JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
            WHERE p.name = '{p_name}' AND d.category = '{doc_category}';"""
        else:
            q = f"""SELECT d.doctor_id, d.name, d.category, h.name, p.name
            FROM doctors d
            LEFT JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
            LEFT JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
            LEFT JOIN hospitals h ON dhc.hospital_id = h.hospital_id
            LEFT JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
            WHERE d.category = '{doc_category}';"""

        cursor.execute(q)
        # print(f"CALL task1('{h_name}', '{p_name}', '{doc_category}');")
        res = cursor.fetchall()
        num = len(res)
        open_results_window(res, num)

    button = Button(input_window, text="Виконати", command=lambda: foo(), font=("Arial", 12))
    button.pack()

