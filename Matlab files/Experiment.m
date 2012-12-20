classdef Experiment<handle
    %Experiment is an object that holds : vectors,
    %functions, etc... it provides easier access to those items and can do
    %operations typical to a lab report.
    
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
        %this method adds an item to the Experiment dictionary.
        %call method - add(item,name(optional)), where item is the item
        %itself, and name is the keyname for which the dictionary will bund
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
            remove(self.dict,key)
        end
        
        function addVectorByFunc(self,name,funcKey,vectorKeys)
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
        %interperts an excel sheet and stores it in Experiment's
        %dictionary. the interpertation is as following:
        %each column must start with a headline: "field(unit)"
        %where field is the name of the vector and the units obviously the
        %unit, but notice that the unit must be in the following
        %format:"kg*T/mm^2".
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
        %updates data from all excel sheets that has been added
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
        %returns an item by the keyword of the item
            item=self.dict(itemName);
        end
        
        function keys=getList(self)
        %returns all keys in one array
            keys=self.dict.keys';
        end
        
        function keys=getFunctionList(self)
        %returns all keys in array that are of type Func
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
        %returns all keys in array that are of type Vector
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
                
    end
    
        
end

