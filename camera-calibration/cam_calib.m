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


% So for calibration, we can take in several (P0A, u', v', w') sets 
% to figure out all the parameters
function [ camera_matrix ] = calibration( input_args )
    % this function will calculate for the camera matrix
    % From raw picture information we got 4 or more sets 
    % of (u', v', w', P0A) pairs as the input args
    camera_m = sym("cam_m", [3,4]);
    eqt = sym("eqt", [3 * size(input_args, 1), 1]);
    
    for i = 1:size(input_args, 1)
        data = input_args(i);
        imgpln = [data(1);data(2);data(3)];
            % coordinate in image plane
        P0A = [data(4);data(5);data(6);1];
            % coordinate in R(3) domain and an 1
        eqtgroup = camera_m*P0A - imgpln;
        for j = 1:3
            eqt(3*(i-1)+j) = eqtgroup(j);
        end
    end
    sol = [0, 0, 0, 0;0, 0, 0, 0;0, 0, 0, 0];
    % if inputs are more than needed, 
    % just average them to avoid errors
    for i = 1:(size(input_args, 1) - 11)
        s = solve(eqt(i:(i+12)));
        sol = sol + [s.a1_1, s.a1_2, s.a1_3, s.a1_4; s.a2_1, s.a2_2, s.a2_3, s.a2_4; s.a3_1, s.a3_2, s.a3_3, s.a3_4;];
    end
    camera_matrix = sol/(size(input_args, 1) - 11);
end
