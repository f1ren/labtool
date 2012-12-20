myExperiment=Experiment('my experiment title'); %create an instance of Experiment
fullPath='C:\Users\TUVAL\Google Drive\MATLAB\examples\polarization results.xlsx';
sheetName='Malus';
myExperiment.addSheet(fullPath,sheetName); %add the sheet to Experiment

fitName='myFit';
myFit=Fit(fitName,'poly1',myExperiment.get('angle'),myExperiment.get('intensity'));

autoplot('new',myFit);