function playSound(status) 
    if strcmp(status,'open')
        filename='applauce.wav';
    elseif strcmp(status, 'half')
        filename='applauce.wav';
    else 
        filename='maybe-next-time.wav';
    end
    [y,Fs] = audioread(filename);
    sound(y,Fs);
end