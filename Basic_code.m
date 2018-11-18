clear;
clc;

videos = ["Wandeling_1a.mp4", "Wandeling_1b.mp4", "Wandeling_1c.mp4", "Wandeling_2a.mp4", "Wandeling_2b.mp4", "Wandeling_2c.mp4"];
walkLength = 3.15;

for j = 1 : length(videos)
    % create video  object
    vid = VideoReader(videos(j));

    %Get properties from video
    framerate = vid.framerate;
    duration = vid.duration;
    vidHeight = vid.Height;
    vidWidth = vid.Width;


    entryState = 1;
    exitState = 0;
    treshold = 0.89;
    entryFrame = -1;
    exitFrame = -1;

    %get video frames
    i = 0;
    while hasFrame(vid)
        frame = readFrame(vid);
        
        if (i == 0)
            startFrame = im2bw(frame, treshold);
        end
        
        whiteDots = im2bw(frame, treshold) - startFrame;
        hasWhitePixels = containsWhitePixels(whiteDots);
        
        if(hasWhitePixels == 1 && entryState == 1)
        entryFrame = i;
        entryState = 0;
        exitState = 1;
        end
        
        if(hasWhitePixels == 0 && exitState == 1)
            exitFrame = i;
            exitState = 0;
            break
        end
        
        i = i + 1;
    end
    
    videos(j)
    speed = 3.15 / ((exitFrame - entryFrame) / framerate)
end



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
