function vOut = horzcat(v1,v2)

% --- ONLY  v1 is a dimensioned variable ------
if(isa(v1,'DimensionedVariable') && ~isa(v2,'DimensionedVariable'))
    arr{1}=v1;
    for i=1:numel(v2)
        arr{i+1}=v2{i};
    end
    vOut=arr;        
end

% --- ONLY  v2 is a dimensioned variable ------
if(~isa(v1,'DimensionedVariable') && isa(v2,'DimensionedVariable'))
    arr{1}=v2;
    for i=1:numel(v1)
        arr{i+1}=v1{i};
    end
    vOut=arr;    
end

%---- BOTH v1 and v2 are dimensioned variables -----
if(isa(v1,'DimensionedVariable') && isa(v2,'DimensionedVariable'))
    if(max(abs(v1.exponents - v2.exponents))>v1.exponentsZeroTolerance)
        vOut = NaN;
        error('Unit inconsistency in addition');
    end
    vOut = v1;
    vOut.value = horzcat(v1.value,v2.value);
end
