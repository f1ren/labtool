from Excel import *
import win32com.client

VEC_MASK = "%s = Vector('%s', '%s', [%s], [%s])"
BAD_CHARS = " ()\"',.;-/^"

h = win32com.client.Dispatch('matlab.application')
h.visible = True

def mat(command):
    print command
    print h.Execute(command)

def vectorCommand(axis, name, unit, vals, errs):
    vals = " ".join(vals)
    errs = " ".join(errs)
    return VEC_MASK % (axis, name, unit, vals, errs)

if __name__ == '__main__':
    # Get table from excel
    t = parseActiveTalbe()

    # Plot
    mat(vectorCommand('x', t.xTitle, t.xUnits, t.xValues, t.xErrors))
    mat(vectorCommand('y', t.yTitle, t.yUnits, t.yValues, t.yErrors))
    mat("autoPlot('new', x, y)")
    """
    self.matlab = MatlabCom()
    self.matlab.open(True)
    self.eval(
    self.matlab.close()
    """
    raw_input("Press enter when done")
