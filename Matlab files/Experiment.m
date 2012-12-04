classdef Experiment<handle
    %Experiment is an object that holds : vectors,
    %functions, etc... it provides easier access to those items and can do
    %operations typical to a lab report.
    
    properties
        name % the name of the experiment
        dict % a dictionary that holds all fields of Experiment
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
            i=1;
            numberOfVectors=numel(headlines);
            while i<=numberOfVectors
                headline=headlines{i};
                dataVector=dataTable(:,i);
                dataVector=dataVector(~isnan(dataVector));
                vectorName=char(regexp(headline,'^.*(?=\()','match'));%extracts the name 
                vectorUnit=char(regexp(headline,'(?<=\()\w*(?=\))','match'));%extracts the unit from the brackets
                if numel(vectorName)==0||numel(vectorUnit)==0;
                    error(['name or unit of ' headline 'is not valid']);
                end
                if i<numberOfVectors
                    if strcmp(headlines{i+1},'error')
                        errorVector=dataTable(:,i+1);
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
            dataList={};
            dataErrorList={};
            for i=1:numel(vectorKeys)
                key=vectorKeys{i};
                item=self.dict(key);
                if strcmp(class(item),'Vector')==0
                    error('vectorKeys must direct to Vector items');
                end
                [data dataError]=item.get;
                dataList=[dataList data];
                dataErrorList=[dataErrorList dataError];
            end
            [result resultError]=self.dict(funcKey).calc(dataList,dataErrorList);
            end
    end
    
        
end

