function autoPlot(command,item1,item2)
%this function plots graphs with name and axes automaticly formated by the
%data contained within the input fields.
%syntax: 
%autoPlot(command,vector1,vector2) - this creates a graph out of two Vector type
%variables
%autoPlot(command,fit) - this creates a graph out of a fit type variable
%command must be a string, and can be either one of the following:
%'new' - create a plot on a new figure
%'add' - create a plot on the last figure
%'name-plotName' - give a custom name to plot. example - autoPlot('name-myplot',item1,item2)
%'save-"FileName"' - saves the plot to folder. example - autoPlot('save-c:\physics\figure.fig',item1,item2)
%                    notice that the file extension is defining the file
%                    output. possible extentions are: fig,jpg.
syntax=' remember that syntax is: autoPlot(command,item1(optional),item2(optional)';
if nargin<1
    error(['must get at least one argument' syntax])
end
if ~isa(command,'char')
    error(['command must be a char type.' syntax]);
end
if nargin>1
    if isa(item1,'Vector')
        if ~isa(item2,'Vector')
            error(['if first item given is of Vector type then the following must be of Vector type as well.' syntax]);
        end
    elseif isa(item1,'Fit')
        if exist('item2','var')
            error(['if first item given is of Fit type then a second item is not allowed.' syntax]);
        end
    else
        error(['undefined item given, items must be either Fit type or Vector type.' syntax]);
    end
end
command=regexp(command,'-','split');
if strcmp(command{1},'save')
    saveas(gcf,command{2})
    return
elseif strcmp(command{1},'name')
    title(command{2})
    return
elseif strcmp(command{1},'add')
    if isempty(get(0,'CurrentFigure'))
        return
    else
        hold all
    end
elseif strcmp(command{1},'new')
    gcf;
    hold off
end  
if strcmp(command{1},'new')||strcmp(command{1},'add')
    if isa(item1,'Fit')
       xVector=item1.getXvector;
       yVector=item1.getYvector;
       fit=item1.getFit;
       plot(fit,xVector.getNum,yVector.getNum);
    elseif isa(item1,'Vector')&&isa(item1,'Vector')
       xVector=item1;
       yVector=item2;
       if yVector.getErrorNum==0
            plot(xVector.getNum,yVector.getNum)
       else  
       errorbar(xVector.getNum,yVector.getNum,yVector.getErrorNum)
       end
    end
    if strcmp(command{1},'new')
       xlabel([xVector.name '(' xVector.getUnit ')']);
       ylabel([yVector.name '(' yVector.getUnit ')']);
       title([xVector.name ' vs ' yVector.name]); 
    end
end
 
end
    

    