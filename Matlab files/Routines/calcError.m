        function err=calcError(func)
             variables=symvar(func);
               varChar=char(variables(1));
               differential=sym (['z_' varChar ],'positive');
               e=(diff(func,variables(1))*differential)^2;
               for i=2:numel(variables)
                   varChar=char(variables(i));
                   differential=sym (['z_' varChar],'positive');
                   e=e+(diff(func,variables(i))*differential)^2;
               end
               e=sqrt(e);
               err=simplify(abs(e));