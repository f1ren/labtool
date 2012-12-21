classdef Fit
  %This Class implements a fit, using a general model of a
  %function with unknown coefficcients, and data vectors the coeeffiecients
  %can be calculated.
    %available method are: 
    %<a href="matlab:help Fit.Fit ">Fit</a>
    %<a href="matlab:help Fit.getName ">getName</a>
    %<a href="matlab:help Fit.getXvector ">getXvector</a>
    %<a href="matlab:help Fit.getYvector ">getYvector</a>
    %<a href="matlab:help Fit.getGoodness ">getGoodness</a>
    %<a href="matlab:help Fit.getFit ">getFit</a>
  properties(SetAccess=private)
      name
      fitModel
      fitResult
      gof
      xVector
      yVector  
  end
  %name - the name of the fit
  %fitModel - the function model. to see model options, type "cflibhelp"
  methods
      function self=Fit(name,fitModel,xVector,yVector)
      %function Fit:
      %constructs a fit objects and goodness of fit struct, and stores the fields 
      %that generated it.
      %constructor syntax: Fit(name,fitModel,xVector,yVector)
      %p.s. to see possible options for fitModel, type cflibhelp
          if nargin<2
              error('must recieve at least two parametes - (name,Fit Model,x vector,y vector)')
          end
          if ~strcmp(class(name),'char')
              error('the name must be a char')
          end
          if ~strcmp(class(fitModel),'char')
              error('Fit Model must be either type "char"')
          end
          if ~strcmp(class(xVector),'Vector')
              error('x data must be a Vector variable')
          elseif ~strcmp(class(yVector),'Vector')
              error('y data must be a Vector variable')
          end 
          self.name=name;
          self.xVector=xVector;
          self.yVector=yVector;
          self.fitModel=fittype(fitModel);
          [self.fitResult self.gof]=fit(xVector.getNum,yVector.getNum,self.fitModel);

      end

      function disp(self)
          fprintf('$Fit Model name "%s":\n',self.name);
          fprintf('Fit Result:\n')
          disp(self.fitResult);
          fprintf('Goodness Of Fit:\n');
          disp(self.gof);         
      end 
      function name=getName(self)
      %function getName:
      %get the name of the fit
      %syntax: Fit.getName
          name=self.name;
      end   
      function xVector=getXvector(self)
      %function getXvector:
      %get the name of the x field of the fit
      %syntax: Fit.getXvector
          xVector=self.xVector;
      end
      function yVector=getYvector(self)
      %function getYvector:
      %get the name of the x field of the fit
      %syntax: Fit.getYvector
          yVector=self.yVector;
      end
      function model=getModel(self)
      %function getModel:
      %get the model of the fit
      %syntax: Fit.getModel
          model=self.fitModel;
      end
     function gof=getGoodness(self)
      %function getGoodness:
      %get the goodness of the fit
      %syntax: Fit.getGoodness
          gof=self.gof;
     end
     function fitResult=getFit(self)
      %function getFit:
      %get the fit result
      %syntax: Fit.fitResult
          fitResult=self.fitResult;
     end
          
           
  end
end  