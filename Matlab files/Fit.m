classdef Fit
  %This class implements a function. upon construction it calculates the
  %error propogation function.
  %dependencies: calcError function
  properties(SetAccess=private)
      name
      fitModel
      funcError
      fitResult
      gof
      xVector
      yVector  
  end
  %name - the name of the function
  %the function itself(stored as "sym")
  %the function Error(stored as "sym")
  methods
      function self=Fit(name,fitModel,xVector,yVector)
          if nargin<2
              error('must recieve at least two parametes - (name,Fit Model,x vector,y vector)')
          end
          if strcmp(class(name),'char')
              self.name=name;
          else
              error('the name must be a char')
          end
          if strcmp(class(fitModel),'sym')
              self.fitModel=fittype(char(fitModel));
          elseif strcmp(class(fitModel),'char')
              self.fitModel=fittype(fitModel);
          else
              error('Fit Model must be either type "sym" or "char"')
          end
          if ~strcmp(class(xVector),'Vector')
              error('x data must be a Vector variable')
          elseif ~strcmp(class(yVector),'Vector')
              error('y data must be a Vector variable')
          end
          self.xVector=xVector;
          self.yVector=yVector;
          [self.fitResult self.gof]=fit(xVector.getNum,yVector.getNum,self.fitModel);
      end
      %constructs a fit objects, and stores the fields that generated it.
      function disp(self)
          fprintf('$Fit Model name "%s":\nFit Model(char):%s\nGoodness Of Fit:\n',self.name,char(self.fitModel));
          disp(self.gof);
      end         
  end
end  