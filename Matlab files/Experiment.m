classdef Experiment<handle
    %Experiment is an object that holds : vectors,
    %functions, etc... it provides easier access to those items and can do
    %operations typical to a kab report.
    
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
            %in construction
            
            
                
        end
    end
    
        
end

