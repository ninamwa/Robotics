function angles_adjust = adjustment(rangescan)
new_ranges = [];
deleted_index = 0;
deleted_ranges=[];
for k = 1:341
    if (rangescan(k) > 20)
        new_ranges = [new_ranges,rangescan(k)];
    else
        deleted_ranges = [deleted_ranges, k];
    end
end
min = 10000;
min_index = 1;
for i = 4: length(new_ranges)-7
    if (new_ranges(i-2) + new_ranges(i) + new_ranges(i+2)) < min
        min_index = i ;
        min = (new_ranges(i-2) + new_ranges(i) + new_ranges(i+2));
    end
end

if min_index < 84  
    for i = 1:length(deleted_ranges)
        if deleted_ranges(i) > min_index && deleted_ranges(i) < 84
            deleted_index = deleted_index + 1;
        end
    end 
else 
    for i = 1:length(deleted_ranges)
        if deleted_ranges(i) < min_index && deleted_ranges(i) > 84
            deleted_index = deleted_index + 1;
        end
    end 
end 
difference = 84 + deleted_index - min_index;
angles_adjust = (240/682)*difference;
angles_adjust= angles_adjust * pi/180;

end
  
