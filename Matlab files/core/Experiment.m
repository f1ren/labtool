classdef Experiment<handle
    %Experiment is an object that holds : vectors,
    %functions, etc... it provides easier access to those items and can do
    %operations typical to a lab report.
    %<a href="matlab:help Experiment.Experiment ">Experiment</a>
    %<a href="matlab:help Experiment.add ">add</a>
    %<a href="matlab:help Experiment.remove ">remove</a>
    %<a href="matlab:help Experiment.addVectorByFunc ">addVectorByFunc</a>
    %<a href="matlab:help Experiment.addSheet ">addSheet</a>
    %<a href="matlab:help Experiment.update ">update</a>
    %<a href="matlab:help Experiment.get ">get</a>
    %<a href="matlab:help Experiment.getList ">getList</a>
    %<a href="matlab:help Experiment.getFunctionList ">getFunctionList</a>
    %<a href="matlab:help Experiment.calc ">calc</a>
    %<a href="matlab:help Experiment.plot ">plot</a>
    %<a href="matlab:help Experiment.makeTable ">makeTable</a>
    properties(SetAccess=private)
        name % the name of the experiment
        dict % a dictionary that holds all fields of Experiment
        sheets %Saves the full path and sheet name each time a user uses "addSheet".
                %this list of sheets is used in "update" command which uses
                %"add sheet" on all this sheets(which means that it updates the experiment
                %to changes in excel files.
    end
    
    methods
        function self=Experiment(name,xlFile,sheetName)
        %function Experiment:
        %constructs the object.
        %call method - Experiment(name,xlFile(optional),addSheet(optional))
        %name is the name of the experiment, and xlFile is the path of an
        %exel file that you wish to interpert and save in Experiment as a
        %set of "Vector" type objects. sheetName is the sheet you wish to
        %interpert, if not specified defult will be the first sheet in the
        %excel file
            if nargin<1
                error('upon construction the Experiment name must be provided')
            end
            sheets={};
            self.name=name;
            self.dict=containers.Map;
            if nargin==2
                self.addSheet(xlFile);
            elseif nargin==3
                self.addSheet(xlFile,sheetName);
            end
        end
        
        function add(self,item,name)
        %function add:
        %this method adds an item to the Experiment dictionary.
        %syntax: Experiment.add(item,name(optional)). where item is the item
        %itself, and name is the keyname for which the dictionary will bind
        %the item to, if not provided, keyname will default to the item's
        %internal name
            if nargin==1
                error('item must be provided')
            elseif nargin==2
                self.dict(item.getName)=item;
            elseif nargin==3
                self.dict(name)=item;
            end
        end
        
        function remove(self,key)
        %function remove
        %syntax: Experiment.remove(key)
        %removes the specified keyword from the dictionary
            remove(self.dict,key)
        end
        
        function addVectorByFunc(self,name,funcKey,vectorKeys)
        %function addVectorByFunc:
        %this function adds a vector by using parameters on a function
        %in Experiment. syntax is Func.addVectorByFunc(self,name,funcKey,vectorKeys)
            [val err]=self.calc(funcKey,vectorKeys);
            if strcmp(class(val),'DimensionedVariable')
                [crap unit]=unitsOf(val);
                unit=unit(2:numel(unit)-1);
                unit=char(sym(regexprep(unit,'][','*')));
                val=u2num(val);
                err=u2num(err);
            elseif strcmp(class(val),'double')
                unit='';
            end 
            self.add(Vector(name,unit,val,err));
        end
          
        function addSheet(self,xlFile,sheetName)
        %function addSheet:
        %syntax: Experiment.addSheet(self,xlFile,sheetName)
        %interperts an excel sheet and stores it in Experiment's
        %dictionary. the interpertation is as following:
        %each column must start with a headline: "field(unit)"
        %where field is the name of the vector and the units obviously the
        %unit, but notice that the unit must be in the following
        %format:"kg*T/mm^2".
        %if the field is unitless then the format for a headline is
        %"field".
            if nargin==1
                error('file path must be provided')
            elseif nargin==2
                [dataTable textTable]=xlsread(xlFile);
            elseif nargin==3
                [dataTable textTable]=xlsread(xlFile,sheetName);
            end
            headlines=textTable(1,:);
            fullRows=~strcmp('',headlines); %find empty rows
            headlines=headlines(fullRows); %delete empty rows from headlines
            dataTable=dataTable(:,fullRows); %delete empty rows from dataTable 
            i=1;
            numberOfVectors=numel(headlines);
            while i<=numberOfVectors
                headline=headlines{i};
                dataVector=dataTable(:,i);
                dataVector=dataVector(~isnan(dataVector));
                vectorUnit=char(regexp(headline,'(?<=\().*(?=\))','match'));  %extracts the unit from the brackets
                if numel(vectorUnit)==0
                    vectorName=headline;  %extracts the name 
                else
                    vectorName=char(regexp(headline,'^.*(?=\()','match'));  %extracts the name 
                end
                if numel(vectorName)==0;
                    error(['name or unit of "' headline '" is not valid, format for headline is: "FieldName(unit)", if unitless then format is "fieldName"']);
                end
                if i<numberOfVectors
                    if strcmp(headlines{i+1},'error')
                        errorVector=dataTable(:,i+1);
                       	errorVector=errorVector(~isnan(errorVector));
                        self.add(Vector(vectorName,vectorUnit,dataVector,errorVector),vectorName);%add vector with error, on the condition that the next column headline is "error"
                        i=i+2;
                    else
                        self.add(Vector(vectorName,vectorUnit,dataVector),vectorName);%add without error
                        i=i+1;  
                    end
                else
                    self.add(Vector(vectorName,vectorUnit,dataVector),vectorName); %add without error(edge of iteration handeling)
                    i=i+1;
                end
            end
            sheetStruct.fullPath=xlFile;
            sheetStruct.name=sheetName;
            self.sheets=[self.sheets sheetStruct];
        end
        
        function update(self)
        %function update  : 
        %updates data from all excel sheets that has been added
        %syntax: Experiment.update
            for sheet=self.sheets
                self.addSheet(sheet.fullPath,sheet.name)
            end
        end
        
        function disp(self) 
        %default display
            fprintf('Experiment "%s" contains the following items: \n',self.name);
            items=self.dict.values;
            for i=1:numel(items)
                fprintf('>%s\n',items{i}.getName);
            end
        end
        
        function item=get(self,itemName)
        %function item:
        %returns an item by the keyword of the item
        %syntax: Experiment.get(key)
            item=self.dict(itemName);
        end
        
        function keys=getList(self)
        %function getList:
        %returns all keys in dictionary
        %syntax: Exeriment.getList
            keys=self.dict.keys';
        end
        
        function keys=getFunctionList(self)
        %function getFunctionList:
        %returns all keys in array that are of type Func
        %syntax: Experiment.getFunctionList
            allKeys=self.dict.keys;
            values=self.dict.values;
            keys={};
            for i=1:numel(values)
                allKeys{i};
                if isa(values{i},'Func')
                    keys=[keys allKeys{i}];
                end
            end
            keys=keys';
        end
                
        function keys=getVectorList(self)
        %function getVectorList
        %returns all keys in array that are of type Vector
        %syntax: Experiment.getVectorList
            allKeys=self.dict.keys;
            values=self.dict.values;
            keys={};
            for i=1:numel(values)
                allKeys{i};
                if isa(values{i},'Vector')
                    keys=[keys allKeys{i}];
                end
            end
            keys=keys';
        end                
        
        function [result resultError]=calc(self,funcKey,vectorKeys)
        %function calc:
        %this function calculates a function(using Func class "calc" method"
        %by a function and Vectors by their keywords.
        %syntax- [result resultError]=Experiment.calc(self,funcKey,vectorKeys)
        %funcKey - the key of the function to calculate
        %vectorKeys - is an array of the keys of the vectors you wish to
        %             calculate.       
            for i=1:numel(vectorKeys)
                key=vectorKeys{i};
                item=self.dict(key);
                if strcmp(class(item),'Vector')==0
                    error('vectorKeys must direct to Vector items');
                end
                vectorList(i)=item;
            end
            [result resultError]=self.dict(funcKey).calc(vectorList);
        end
            
        function plot(self,command,key1,key2)
            %function plot:
            %plots a graph by calling the autoPlot routine
            %syntax - plot(command,key1,key2(optional))
            %the syntax is the same as autoPlot(for more info type "help
            %autoPlot", the only difference is that key1 and key2 are the
            %keys to the wanted field instead of the field itself.
            if nargin<2
                error('not enough arguments given. remember syntax is plot(command,key1,key2(optional))');
            elseif nargin==2
                autoPlot(command);
            elseif nargin==3
                autoPlot(self.dict(key1));
            elseif nargin==4
                autoPlot(command,self.dict(key1),self.dict(key2));
            else
                error('too many arguments given. remember syntax is plot(command,key1,key2(optional))');
            end
        end
        function makeTable(self,fileName,sheetName,keyList)
        %function makeTable:
        %makes a table using the makeTable routine to create an excel table.
        %syntax(fileName,sheetName,keyList)
        %where keyList is for example {key1 key2 key3 ...} where each key
        %is a name of a field the dictionary.
            for i=1:numel(keyList)
                if ~isKey(self.dict,keyList{i})
                    error(['key "' keyList{i} '" does not exist in Experiment'])
                end
                vectorList{i}=self.get(keyList{i});
            end
            makeTable(fileName,sheetName,vectorList);
        end         
    end
    

        
end

