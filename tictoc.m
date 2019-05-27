function tictoc(time)

tic;
while 1
    t = toc;
    if t == time
        disp(t)
        break
    end
end
end