from win32com.client import Dispatch
import re
from Table import Table

excel = Dispatch("Excel.Application")

TABLE_MASK = "table"
EVALUATION_MASK = ""

def find(sheet, value):
    return sheet.UsedRange.Find(value)

"""
def cords(address):
    address = address.replace('$','')
    x = re.findall('[a-zA-Z]+', address)[0]
    x = x.upper()
    x = ord(x) - ord('A') + 1
    y = int(re.findall('\d+', address)[0])
    return (x, y)
"""

def parseTable(handle):
    inTable = handle.Offset

    # Get table title
    title = inTable(1,2).Value

    # Build table object
    outTable = Table(title)

    # Get axis titles
    outTable.yTitle = inTable(2, 1).Value
    outTable.xTitle = inTable(2, 3).Value

    # Get axis units
    outTable.yUnits = inTable(3, 1).Value
    if outTable.yUnits is None:
        outTable.yUnits = ""
    outTable.xUnits = inTable(3, 3).Value
    if outTable.xUnits is None:
        outTable.xUnits = ""

    # Iterate over the table
    i = 4
    while (not inTable(i, 1).Value is None):
        outTable.yValues.append(str(inTable(i, 1).Value))
        outTable.yErrors.append(str(inTable(i, 2).Value))
        outTable.xValues.append(str(inTable(i, 3).Value))
        outTable.xErrors.append(str(inTable(i, 4).Value))
        i += 1

    return outTable

def parseActiveTalbe():
    activeSheet = excel.ActiveSheet
    return parseTable(find(activeSheet, TABLE_MASK))

if __name__ == "__main__":
    parseActiveTalbe()
