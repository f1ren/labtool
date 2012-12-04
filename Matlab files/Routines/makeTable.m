function makeTable(fileName,sheetName,vectorList)
%makeTable - makes a table by using Vector type inputs. each vector will
%get a row, and each row will be composed of the headline of the vector
%followed by the data
%syntax - makeTable(fileName,sheetName,vectorList).



if ~isa(fileName,'char')
    error('file name must be a char type, remember syntax is: makeTable(fileName,sheetName,vectorList)')
elseif ~isa(sheetName,'char')
    error('sheet name must be a char type, remember syntax is: makeTable(fileName,sheetName,vectorList)')
elseif ~isa(vectorList,'cell')
    error('vector list must be a cell array type, remember syntax is: makeTable(fileName,sheetName,vectorList)')
end
filePath=which(fileName);
if numel(filePath)==0
    xlswrite(fileName,'new sheet',sheetName);
    deleteSheet(fileName,'sheet1');
    deleteSheet(fileName,'sheet2');
    deleteSheet(fileName,'sheet3');
end
headlines={};
table={};
j=1;
for i=1:numel(vectorList)
    vector=vectorList{i};
    if ~isa(vector,'Vector')
        error('vector list must be composed of Vector type only')
    end
    [garbadge unit]=unitsOf(vector.unit);
    headlines{j}=[vector.name '(' unit ')'];
    data=num2cell(vector.getNum);
    table(1:numel(data),j)=data;   
    j=j+1;
    dataError=num2cell(vector.getErrorNum);
    headlines{j}='error';
    table(1:numel(dataError),j)=dataError;
    j=j+1;
end
xlswrite(fileName,[headlines;table],sheetName);

    

    
    
end

