from win32com.client import Dispatch
excel = Dispatch("Excel.Application")

excel.ActiveSheet
