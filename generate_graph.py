from Excel import *
import win32com.client
import re

VEC_MASK = "%s = Vector('%s', '%s', [%s], [%s])"
BAD_CHARS = " ()\"',.;-/^"

PLOT_LINEAR_MASK = "[s, i] = PlotLinear('%s', '%s', '%s', '%s', '%s', %s, %s, %s, %s)"

h = win32com.client.Dispatch('matlab.application')
#h.visible = True

def mat(command):
    print command
    matRes = h.Execute(command)
    variables = re.findall('\n(.*?) =\n', matRes)
    values = re.findall('   (.*?)\n\n', matRes)
    resultsDict = {}
    for (var, val) in zip(variables, values):
        resultsDict[var] = val
    return resultsDict

def vectorCommand(axis, name, unit, vals, errs):
    vals = " ".join(vals)
    errs = " ".join(errs)
    return VEC_MASK % (axis, name, unit, vals, errs)

def matlabVec(vec):
    return "[%s]" % " ".join(vec)

def PlotLinearCommand(name, xTitle, yTitle, xUnits, yUnits, x, y, xErrs, yErrs):
    x = matlabVec(x)
    y = matlabVec(y)
    xErrs = matlabVec(xErrs)
    yErrs = matlabVec(yErrs)
    return PLOT_LINEAR_MASK % (name, xTitle, yTitle, xUnits, yUnits, x, y, xErrs, yErrs)

if __name__ == '__main__':
    # Get table from excel
    t = parseActiveTalbe()

    # Plot
    res = mat(PlotLinearCommand(t.title, t.xTitle, t.yTitle, t.xUnits, t.yUnits, \
            t.xValues, t.yValues, t.xErrors, t.yErrors))

    setSlopeAndIntercept(res['s'], res['i'])
    """
    mat(vectorCommand('x', t.xTitle, t.xUnits, t.xValues, t.xErrors))
    mat(vectorCommand('y', t.yTitle, t.yUnits, t.yValues, t.yErrors))
    mat("autoPlot('new', x, y)")
    self.matlab = MatlabCom()
    self.matlab.open(True)
    self.eval(
    self.matlab.close()
    """
    raw_input("Press enter when done")
