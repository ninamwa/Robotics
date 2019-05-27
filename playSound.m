function playSound(status) 
    if strcmp(status,'open')
        filename='opendoor.wav';
    elseif strcmp(status, 'half')
        filename='halfopen.wav';
    elseif strcmp(status, 'closed')
        filename='doorclosed.wav';
    end
    [y,Fs] = audioread(filename);
    sound(y,Fs);
end