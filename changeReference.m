function bol = changeReference(nr, ref, x_real, y_real)
bol = false;
    if nr <= 12 && (x_real+150 > ref(1))            
        bol = true;
    elseif nr>12 && nr <= 20 && y_real+150 > ref(2)
        bol = true; 
    elseif nr >20 && nr <= 44 && x_real-150  < ref(1)
        bol = true;
    elseif nr > 44 && nr <= 101 && y_real-150 < ref(2)
        bol = true;
    end
end
