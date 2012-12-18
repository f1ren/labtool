from Excel import *
import re
from Matlab import *

if __name__ == '__main__':
    # Get table from excel
    t = parseActiveTalbe()

    # Plot
    res = mat(PlotLinearCommand(t.title, t.xTitle, t.yTitle, t.xUnits, t.yUnits, \
            t.xValues, t.yValues, t.xErrors, t.yErrors))

    setSlopeAndIntercept(res['s'], res['i'])
    raw_input("Press enter when done")
