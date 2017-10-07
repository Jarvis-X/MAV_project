% ----------------- positive calculation starts here ----------------- 
syms u v ux vx wx f p Or oc Rco Pco P0A;
Rco = sym("Rco", [3,3]);
Pco = sym("Pco", [3,1]);
P0A = sym("P0A", [3,1]);

% res is a 3x1 matrix holding u', v' and w'
res=[f/p, 0, Or;0, f/p, oc;0,0,1]*[Rco, Pco]*[P0A;1];
% respectively ux, vx, wx
ux = res(1);
vx=res(2);
wx=res(3);

% And in pixel domain u = ux/wx, v = vx/wx
u = ux/wx;
v = vx/wx;
% ------------------ positive calculation ends here ------------------ 


% So for calibration, we can take in several (P0A, u, v) sets 
% tofigure out all the parameters
