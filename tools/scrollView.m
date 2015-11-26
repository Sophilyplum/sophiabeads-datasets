function scrollView(vol, dim, limits)
%SCROLLVIEW
% Function to scroll through a reconstructed volumetric
% data within the same figure window.
% 
% INPUT: 
%	vol: The reconstructed volume to view.
%	dim: Dimension in which to view the volume along
%		dim = 1 or 2: Vertical -- xz- or yz-slices;
%		dim = 3: Horizontal -- xy-slices.
% 	limits: Range of voxel values to display in the figure window.
%
% DEFAULT VALUES:
%   dim = 3; (Horizontal slices)
%   limits = [min(vol(:)) max(vol(:))];
% 
% Copyright (c) 2015 Sophia Bethany Coban, David Szotten
% Code is available via the SophiaBeads Datasets project.
% University of Manchester.

app.size = size(vol);

% Cannot plot vectors; volume has to be reshaped in 3D!
if min(app.size) == 1
    fprintf('Wrong size: ');
    disp(app.size);
    return
end

% Can only display real values! 
if ~isreal(vol)
    warning('Only real values can be displayed!')
end

% Setting defaults for image range limits.
if nargin < 3
    app.limits = [min(vol(:)), max(vol(:))]; % Default option is to adjust the plot range.
    if app.limits(1) == app.limits(2)
        app.limits(1) = app.limits(1)-eps;
        app.limits(2) = app.limits(2)+eps;
    end
else
    app.limits = limits;
end

% Setting defaults for 'plot-along' dimensions.
if nargin < 2
    app.dim = 3; % Default option is to plot horizontal slices.
else
    app.dim = dim;
end

maxval = size(vol, app.dim); % Pick the maximum slice number in the appropriate dimension.

% Set figure atts.
figure;
app.axis = gca;
app.figure = gcf;

% Generate constants for use in uicontrol initialization
pos=get(app.axis,'position');
% This will create a slider which is just underneath the axis.
Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];
% Creating Uicontrol
h=uicontrol('style','slider','units','normalized','position',Newpos,'callback',@sfScroll,'min',1,'max',maxval, 'value', floor(maxval/2), 'sliderstep', [1/maxval 10/maxval]);
sfScroll(h);

%%% SUBFUNCTIONS %%%
function sfScroll(varargin)
% Function to scroll through slices:

    handle = varargin{1};
    scrollVal = floor(get(handle,'value'));
        
     switch app.dim
         case 1
            sfImagescWrapper(vol(scrollVal,:,:),app.limits)
            title(['Vertical Slice ' num2str(scrollVal)],'FontWeight','bold','Fontsize',12);
         case 2
            sfImagescWrapper(vol(:,scrollVal,:),app.limits)
            title(['Vertical Slice ' num2str(scrollVal)],'FontWeight','bold','Fontsize',12);
         case 3
            sfImagescWrapper(vol(:,:,scrollVal),app.limits)
            title(['Horizontal Slice ' num2str(scrollVal)],'FontWeight','bold','Fontsize',12);
    end
end


function sfImagescWrapper(image, limits)
% Function to plot at current value:   

    imagesc(squeeze(image)', limits)
    colormap(gray);axis image;axis off;
    %     colorbar % uncomment this if you wish to place a colorbar next to the slices.
end

end % End of main function

