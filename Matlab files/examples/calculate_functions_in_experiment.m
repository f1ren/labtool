myExperiment=Experiment('my experiment title'); %create an instance of Experiment
fullPath='C:\Users\TUVAL\Google Drive\MATLAB\examples\polarization results.xlsx';
sheetName='Malus';
myExperiment.addSheet(fullPath,sheetName); %add the sheet to Experiment
functionName='my func';
func='cos(x)';
myExperiment.add(Func(functionName,func)); %add a function to Experiment

%if you wish to get a result of the computation use this method
[value valueError]=myExperiment.calc(functionName,{'angle'})

%if you wish to calculate and add the field use this method
fieldName='myField';
myExperiment.addVectorByFunc(fieldName,functionName,{'angle'});
myExperiment