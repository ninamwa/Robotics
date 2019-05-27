function bol = changeReference(nr, ref, x_real, y_real)
bol = false;
    if nr <= 12 && (x_real+300 > ref(1))            
        bol = true;
    elseif nr>12 && nr <= 21 && y_real+300 > ref(2)
        bol = true; 
    elseif nr >21 && nr <= 29 && x_real-300  < ref(1)
        bol = true;
    elseif nr > 29 && nr <= 45 && y_real-300 < ref(2)
        bol = true;
    end
end
