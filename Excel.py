from win32com.client import Dispatch
excel = Dispatch("Excel.Application")

def parseTable():
    graph_name = table[0][0]
    col_names = table[1]
    col_a = []
    col_b = []
    err_a = []
    err_b = []
    #for a_val, a_err, b_val, b_err in table:
    for x in table:
        print x
        """
        col_a.append(a_val)
        err_a.append(a_err)
        col_b.append(b_val)
        err_b.append(b_err)
        """

    print "Name: %s" % graph_name

def parseCol():
    sel = excel.Selection
    for i in sel:
        print i

if __name__ == "__main__":
    parseCol()
