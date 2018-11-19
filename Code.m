clear;
clc;

videos = ["Wandeling_1a", "Wandeling_1b", "Wandeling_1c", "Wandeling_2a", "Wandeling_2b", "Wandeling_2c"];
newVideoEnds = [250 290 220 170 230 330];
walkLength = 3.15;
treshold = 0.79;

for i = 1 : length(videos)
    vid = VideoReader(videos(i) + ".mp4");

    vwidth = vid.Width();
    vheight = vid.Height();
    framerate = vid.framerate;

    fprintf("%s:\n", videos(i));
    pos = 1;
    plotVals = zeros(newVideoEnds(i));
    startPoint = -1;
    endPoint = -1;
    speed = 0;

    while hasFrame(vid) && pos < newVideoEnds(i)
        frame = readFrame(vid);
        binframe = im2bw(frame, treshold);
    
        for j = 1 : vwidth
            for k = 1 : vheight
                if (k > vheight / 2) binframe(k, j) = 0; end
            end
        end
    
        binframe = bwpropfilt(binframe, 'perimeter', 1); %% isolate object with biggest perimeter

        if (containsWhitePixels(binframe) == 1)
            props = regionprops(binframe, 'Centroid');
            plotVals(pos) = props(1).Centroid(2);
            
            if (startPoint == -1) startPoint = pos; 
            else endPoint = pos; end
        end

        pos = pos + 1;
    end

    steps = 0;
    valrange = 1 : length(plotVals);
    maxima = islocalmax(plotVals, 'MinSeparation', 11);

    for L = valrange
        for m = valrange
            if (maxima(L, m) == 1)
                steps = steps + 1;
            end
        end
    end

    figure,
    plot(valrange, plotVals, valrange(maxima), plotVals(maxima), 'bo');
    hold on

    disp(sprintf('\ttotal speed = %f m/s', walkLength / ((endPoint - startPoint) / framerate)));
    fprintf('\tstep length = %f m/step\n', walkLength / steps);
    fprintf('\tstep time = %f s/step\n', ((endPoint - startPoint) / framerate) / steps);
end

%% Checks if the image contains white pixels
function output = containsWhitePixels(image)
    output = 0;

    for i = 1 : size(image, 1)
        for j = 1 : size(image, 2)
           pixel = image(i, j);
           
           if(pixel == 1) 
               output = 1;
           end
        end
    end
end
