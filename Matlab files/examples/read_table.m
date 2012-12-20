myExperiment=Experiment('my experiment title'); %create an instance of Experiment
fullPath='C:\Users\TUVAL\Google Drive\MATLAB\examples\polarization results.xlsx';
sheetName='Malus';
myExperiment.addSheet(fullPath,sheetName); %add the sheet to Experiment
myExperiment %display the fields in Experiment
a=myExperiment.get('angle') %retrieve field 'angle' to variable 'a'