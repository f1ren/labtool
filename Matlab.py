import re
import win32com.client

VEC_MASK = "%s = Vector('%s', '%s', [%s], [%s])"
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

