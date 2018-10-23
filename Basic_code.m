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

%get video frames
for i=1:no_frames
    frame = read(vid,i);
    
    %% Frame processing here %%
end

test=read(vid,160);
test_bin=imbinarize(test, 0.795);
imshow(test)
se = strel('disk',10);
dil=imdilate(test, se);
imshow(dil)
