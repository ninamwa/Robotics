%
% sample code to test the QR code decoder from ZXing using an image directly from a
% webcam
%
% Joao Sequeira, 2013
%
function msg = searchQR()
clear all
clf


%javaaddpath('.\zxing-2.1\core\core.jar');
%javaaddpath('.\zxing-2.1\javase\javase.jar');

video_devs = imaqhwinfo('winvideo');
n_vids = length(video_devs.DeviceIDs);

if n_vids==0
    disp('No winvideo devices found - aborting');
    beep;
    return
else
    disp([num2str(n_vids), ' cameras available - paused']);
%     pause
end

for k=1:n_vids,
    vid{k} = videoinput('winvideo',video_devs.DeviceIDs{k});
%     preview(vid{k});
    % the type of images is easily checked reading the structure vid{}
    
%     start(vid{k});
%   stop(vid{k});
end


button=1;
while button==1,
    for k=1:n_vids,
        figure(k)
%         frame = getsnapshot(vid{k});
        start( vid{k} );
        frames10 = getdata( vid{k} );
        % test each of the 10 frames acquired until a non-black (all zeros)
        % frame is found
        for k1=1:10,
            frame_sum = sum(sum(sum( frames10(:,:,:,k1) )));
            if frame_sum>0
                break
            end
        end
        if frame_sum>0
            frame = frames10(:,:,:,k1);
        end

        % the builtin webcam uses the YCbCr colorspace
        %
        % the number of the this webcam is not always the same so it may be
        % necessary to adjust the conditions in the if...else...end
        if k==2
            frame = ycbcr2rgb(frame);
            image( frame );
        else
            image( frame );
%             image( ycbcr2rgb(frame) );
%             image( hsv2rgb(frame) );
        end
        colormap jet
    
        % the decoder only works for RGB images
        message = decode_qr( frame );
        if isempty(message)==0
            disp( message );
            beep,
        end
    end

%     [x,y,button] = ginput(1);
     
%     pause(1);
end

for k=1:n_vids,
    delete(vid{k});
end

end

