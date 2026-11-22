import mysql.connector

# ---------------------------------------------------------------------
# Connection (one for the whole program)
# ---------------------------------------------------------------------
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="imanedoaa",   # <-- put your MySQL password here
    database="rlms",
     charset="utf8mb4",
    collation="utf8mb4_0900_ai_ci",
    autocommit=True         # each statement is saved immediately
)


# ---------------------------------------------------------------------
# Task 3: parameterized query
# ---------------------------------------------------------------------
def task3_inservice_units(conn):
    print("== Task 3: InService units of a laboratory ==")
    cursor = conn.cursor()

    lab_name = "Physics Laboratory"

    # Parameterized SQL query
    query = """
    SELECT EU.serialNo, EM.commercialName
    FROM EquipmentUnit EU
    JOIN EquipmentModel EM
        ON EU.modelId = EM.modelId
    JOIN Laboratory L
        ON EU.labId = L.labId
    WHERE L.name = %s
      AND EU.status = 'InService'
    """

    # Execute query with parameter
    cursor.execute(query, (lab_name,))

    # Display results
    for serialNo, modelName in cursor.fetchall():
        print(f"  {serialNo} {modelName}")

    cursor.close()


# ---------------------------------------------------------------------
# Task 4: query the view LaboratoryStockSummary
# ---------------------------------------------------------------------
def task4_low_stock(conn):
    print("== Task 4: LOW stock (view LaboratoryStockSummary) ==")
    cursor = conn.cursor()

    cursor.execute("""
        SELECT *
        FROM LaboratoryStockSummary
        WHERE stockLevel COLLATE utf8mb4_unicode_ci = 'LOW'
    """)

    rows = cursor.fetchall()

    for row in rows:
        print(row)

    cursor.close()



# ---------------------------------------------------------------------
# Task 5: call the stored procedure RestockLab
# ---------------------------------------------------------------------
def task5_restock(conn):
    print("== Task 5: call RestockLab ==")
    cur = conn.cursor()
    lab_id, cons_id, qty = 1, 2, 3
    args = (lab_id, cons_id, qty, 0)        # 4th value: placeholder for the OUT parameter
    result = cur.callproc("RestockLab", args)
    print(f"  Restocked lab {lab_id}, consumable {cons_id} by {qty}")
    print(f"  newQuantity = {result[3]}")
    cur.close()


# ---------------------------------------------------------------------
# Task 6: an INSERT rejected by the certification trigger
# ---------------------------------------------------------------------
print("== Task 6: INSERT rejected by a trigger ==")
cur = conn.cursor()
try:
    cur.execute("INSERT INTO Reserves (resId, serialNo) VALUES (%s, %s)", (1, "U4"))
    print("  Inserted (unexpected)")
except mysql.connector.Error as err:
    print(f"  Rejected by the database (error {err.errno})")
    print(f"  Trigger message: {err.msg}")
cur.close()


# ---------------------------------------------------------------------
# Main: run the tasks in order, then close the connection
# ---------------------------------------------------------------------
def run_task(name, func):
    try:
        func(conn)
    except mysql.connector.Error as err:
        print(f"  {name} FAILED: error {err.errno}: {err.msg}")

run_task("Task 3", task3_inservice_units)
run_task("Task 4", task4_low_stock)
run_task("Task 5", task5_restock)

conn.close()
print("Program finished normally.")
