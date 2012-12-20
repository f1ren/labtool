f=Func('myFunc','a^4*4/g^5*d^1/2*cos(x)^2') %creates a function instance, calculates function error
                                            %default display gives 'char'
                                            %and 'latex' of the function
                                           
f.getVariables %returs an array of the variables of the function in their right order
a=Vector('vec1','us',[1 0 3.3 5],[0.1 0.2 0.1 0.05]);
b=Vector('vec2','s',3,0.2);
c=Vector('vec3','m',7,1);
d=Vector('vec4','',[3 3 4 3],[0.01 0.01 0.01 0.01]);
[val err]=f.calc([a b c d]);
disp('value: ');
val
disp('error:')
err

[temp, unit]=unitsOf(val);
unit


