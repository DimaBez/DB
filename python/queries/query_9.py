from tkinter import *
import mysql.connector


def query1(doc_category, med_type, med_name):
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
            query = f"""SELECT d.doctor_id, d.name, d.category, h.hospital_name
                    FROM doctors d
                    INNER JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
                    INNER JOIN hospitals h ON dhc.hospital_id = h.hospital_id
                    WHERE h.hospital_name = '{med_name}' AND d.category = '{doc_category}';"""
        elif med_type == "Поліклініка":
            query = f"""SELECT d.doctor_id, d.name, d.category, p.polyclinic_name
                        FROM doctors d
                        INNER JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
                        INNER JOIN polyclinics p ON dpc.polyclinic_id = p.polyclinic_id
                        WHERE p.polyclinic_name = '{med_name}' AND d.category = '{doc_category}'"""
        elif med_type == "Всі":
            query = f"""SELECT d.doctor_id, d.name, d.category, dpc.polyclinic_id, dhc.hospital_id 
                        FROM doctors d
                        LEFT JOIN doc_hospital_contracts dhc ON d.doctor_id = dhc.doctor_id
                        LEFT JOIN doc_polyclinic_contracts dpc ON d.doctor_id = dpc.doctor_id
                        WHERE d.category = '{doc_category}';"""

        cursor = connection.cursor() 
        cursor.execute(query)
        response = cursor.fetchall()
        return response

    except mysql.connector.Error as e:
        print(e)
        
    connection.close()
    return e



def button_click_9(open_results_window) -> None:
    # Створення нового вікна
    input_window = Toplevel()
    input_window.title("Введіть дані")
    input_window.geometry("800x500")
    # input_window.geometry("1536x864")  # розмір всього екрану

    # Віджети Entry для вводу типу медичного закладу та назви медичного закладу
    input_frame = LabelFrame(input_window, text="Введіть пошукові дані", font=("Arial", 14))  # Збільшення розміру шрифту
    input_frame.pack(padx=10, pady=10)

    doc_label = Label(input_frame, text="Спеціальність лікаря:", font=("Arial", 12))  # Збільшення розміру шрифту
    doc_label.grid(row=0, column=0, sticky=W)
    doc_entry = Entry(input_frame, font=("Arial", 12))  # Збільшення розміру шрифту
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
        doc_category = doc_entry.get()
        med_type = type_entry.get()
        med_name = name_entry.get()
        response = query1(doc_category, med_type, med_name)
        open_results_window(response)

    button = Button(input_window, text="Виконати", command=lambda: foo(), font=("Arial", 12))  # Збільшення розміру шрифту
    button.pack()

