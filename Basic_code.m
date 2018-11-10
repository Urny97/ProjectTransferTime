clear;
clc;

% create video  object
vid = VideoReader('Wandeling_1a.mp4');

%Get properties from video
framerate = vid.framerate;
duration = vid.duration;
no_frames = vid.NumberOfFrames;
vidHeight = vid.Height;
vidWidth = vid.Width;

frames = zeros(0, no_frames - 1);

entry = 1;
exit = 0;
treshold = 0.87;
startFrame = im2bw(read(vid,1), treshold);

%get video frames
for i=1:no_frames
    frame = read(vid,i);
    
    %% Frame processing here %%;
    whiteDots = im2bw(frame, treshold) - startFrame;
    %imshow(whiteDots)
    hasWhitePixels = containsWhitePixels(whiteDots);
    
    if(hasWhitePixels == 1 && entry == 1)
       entryFrame = i;
       entry = 0;
       exit = 1;
    end
    
    if(hasWhitePixels == 0 && exit == 1)
        exitFrame = i;
        exit = 0;
    end
end

%load frames
%implay(vid);

%test = im2bw(read(vid,160), 0.9);
%testWhite = test > 0.8
%L = bwlabel(test);
%imshow(test)

speed = 3.15 / ((exitFrame - entryFrame) / framerate)

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
    
    %if(output ~= 1) 
     %   output = 0;
    %end
end
