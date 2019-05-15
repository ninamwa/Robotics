function angles_adjust = adjustment(rangescan)
new_ranges = [];
for k = 1:341
    if(~(rangescan(k) < 20))
        new_ranges = [new_ranges,rangescan(k)];
    end  
[value, index] = min(new_ranges); %rightpoints
difference = abs(84-index);
angles_adjust = (240/682)*difference;


end

