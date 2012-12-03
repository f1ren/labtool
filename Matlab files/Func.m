classdef Func
  %This class implements a function. upon construction it calculates the
  %error propogation function.
  properties(SetAccess=private)
      name % The name of the function
      func % The function itself  as a symbolic type
      funcError % The function error itself as a symbolic type
  end

  methods
      function self=Func(name,func)
      %Constructs a function instance and calculates and store function error
      %syntax Func(name,func)
      %where func is a symbolic of the function, or a char array
          if nargin<2
              error('must recieve at least two parametes - (name,function)')
          end
          if strcmp(class(name),'char')
              self.name=name;
          else
              error('the name must be a char')
          end
          if strcmp(class(func),'sym')
              self.func=func;
          elseif strcmp(class(func),'char')
              self.func=sym(func);
          else
              error('function must be either type "sym" or "char"')
          end
          self.funcError=calcError(self.func);
      end
      
      function disp(self)
          errChar=regexprep(char(self.funcError),'z_','\\Delta_');
          errLatex=regexprep(latex(self.funcError),'z_','\\Delta_');% a small fix to make "z_" error character to"\delta_"
          fprintf('$function "%s":\nfunction(char):\n%s\nfunction(latex):\n%s\nfunction error(char):\n%s\nfunction error(latex):\n%s\n',self.name,char(self.func),latex(self.func),errChar,errLatex);
      end
      function [resultFunc resultFuncError]=calc(self,dataList,dataErrorList)
      %calculate the function by giving it parameters
      %syntax- [resultFunc resultFuncError]=Func.calc(dataList,dataErrorList(optional))
      %data List is a list of columns or rows, for example dataList={a b c}
      %where a,b,c are either columns or rows.
      %errordataList is the same as dataList, only it is optional wether
      %you wish to calculate error as well.
      %NOTICE - it is very important to keep the input lists syncronous to
      %those of the function, to see the right order use the "getVariables"
      %method
          variables=symvar(self.func);
          if numel(dataList)~=numel(variables)
              error(['number of input parameters(function input) must be - ' num2str(numel(variables))]);
          end
          if nargin<3
              for i=1:numel(variables)
                  dataErrorList{i}=0;
              end
              %if no error parameters have been given, then zero all
              %parameters since the error is 0
          else
              if numel(dataErrorList)<numel(variables)
                  error(['number of input error parameters(function input) must be - ' num2str(numel(variables))]);
              end
          end
          %change the function and the function error operations to
          %"cell to cell" operations
          fun=char(self.func);
          fun=strrep(fun,'*','.*');
          fun=strrep(fun,'^','.^');
          fun=strrep(fun,'/','./');
          funError=char(self.funcError);
          funError=strrep(funError,'*','.*');
          funError=strrep(funError,'^','.^');
          funError=strrep(funError,'/','./');
          for i=1:numel(dataList)
            var=char(variables(i));
            fun=regexprep(fun,['\<' var '\>'],['dataList{' num2str(i) '}']);
            funError=regexprep(funError,['\<' var '\>'],['dataList{' num2str(i) '}']);
            funError=regexprep(funError,['\<' 'z_' var '\>'],['dataErrorList{' num2str(i) '}']);
            %replace variable with parameter
          end
          resultFunc=eval(fun);
          resultFuncError=eval(funError);
          %evaluate string as if it was a command
      end
      
      function name=getName(self)
      %returns the name of the function
          name=self.name;
      end
      
      function funcVar=getVariables(self)
      %returns the variables of the function 
          funcVar=symvar(self.func);
      end
          
  end
end  
