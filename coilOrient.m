%Yagna Pathak
%Extract transformation matrix from ASA excel sheets
%Calculate the equivalent angle axis of each orientation

%Read excel files to determine coil orientation

% inputDir = ('C:\data\DepressionStudy\rTMS_Depression\CoilOrient');
% Namepref = 'SB_12*';
% sub = []; %name of your struct variable

%sm = mean of std dev
%meanpos = mean of stimulation positions
%sdpos = std dev of stimulation positions
%t = transformation matrix


function [sm meanpos sdpos t sub] = coilOrient(inputDir,Namepref,sub)
A = [];
P = [];
MP = [];
SP = [];
MAT = [];

fileList = dir(fullfile(inputDir,Namepref)); %change to match with wildcards


% for x=1:length(fileList)
%     fileName = fileList(x,1).name;
%     MAT = [xlsread(fileName,-1)]; %select whole matrix
%     [m,n] = size(MAT);
%     
%     P = [P; MAT(1:m-2,1:3)]; %position matrix
%     A = [A; MAT(1:m-2,4:n)]; %rotation matrix
%        
%     MP = [MP;MAT(m-1,1:3)]; %mean position matrix for each session
%     SP = [SP;MAT(m,1:3)]; %stdev position matrix for each session  
% end

for x=1:length(fileList)
    fileName = fileList(x,1).name;
    MAT = xlsread(fileName,'sheet2'); %select whole matrix
    [m,n] = size(MAT);
    
    P = [P; MAT(1:m-2,5:7)]; %position matrix
    A = [A; MAT(1:m-2,8:n)]; %rotation matrix
    [row col] = size(A);
       
    MP = [MP;MAT(m-1,5:7)]; %mean position matrix for each session
    SP = [SP;MAT(m,5:7)]; %stdev position matrix for each session  
end

%%x(xls) = -y(asa) 
%%y(xls) = x(asa)

cp(:,1) = P(:,2);
cp(:,2) = -1*P(:,1);
cp(:,3) = P(:,3);
P = cp; %position corrected

sd(:,1) = SP(:,2);
sd(:,2) = SP(:,1);
sd(:,3) = SP(:,3);
SP = sd;%std dev corrected


sm = mean(SP); % mean of the std dev (avg variation within session)
meanpos = mean(P); %mean of the positions for the entire course of treatment
sdpos = std(P); %std. dev of the positions for the entire course of treatment




%transformed matrix
for i = 1:row
    %rotation matrix updated 01-15-13
    x = [A(i,1) A(i,2) A(i,3)];
    y = [A(i,4) A(i,5) A(i,6)];
    z = [A(i,7) A(i,8) A(i,9)];
    
    p(:,:,i)=[P(i,1); P(i,2); P(i,3)]; %position
    r(:,:,i)= [x;y;z]; %rotation matrix
    t(:,:,i)= [x P(i,1); y P(i,2); z P(i,3); 0 0 0 1]; %transformation matrix
    
%     %extracting angles from the rotation matrix (assume order is x-y-z)
%     b(i) = atan2(-r(3,1,i), (r(1,1,i)^2+r(2,1,i)^2)^0.5); %Ry
%     a(i) = atan2(r(2,1,i)/cos(b(i)), r(1,1,i)/cos(b(i))); %Rz
%     g(i) = atan2(r(3,2,i)/cos(b(i)), r(3,3,i)/cos(b(i))); %Rx
        
end

sub.trans = t;
sub.rot = r;
sub.pos = p;
sub.mp = MP;
sub.sp = SP;
sub.meansd = sm;
sub.meanpos = meanpos;
sub.sdpos = sdpos;


















% r = [];
% x = [];
% y = [];
% z = [];
% 
% target = [25.7, 30.9, 71.5]; % target location
% 
% %initial matrix(coil wand is along the negative y axis in the x-y plane)
% x0 = [5;-5;0];
% y0 = [0;0;-5];
% z0 = [0;0;0];
% 
% vref = [x0 y0 z0];
% 
% x_t = [];
% y_t = [];
% z_t = [];
% b = [];
% a = [];
% g = [];
% 

% 
% 
% 
% RW.theta = [];
% RW.axis = [];
% % 
% % Representing with the angle-axis notation
% for i = 1: length(RW.rot)
%     R = RW.rot(:,:,i);
%     RW.theta(i) = acos((trace(R)-1)/2);
%     RW.axis(:,i) = 1/(2*sin(RW.theta(i)))*[R(3,2)-R(2,3); R(1,3)-R(3,1); R(2,1)-R(1,2)];
%     RW.theta(i) = RW.theta(i)*180/pi;
% end
% 
% axis = RW.axis';
% 
% starts = [0 0 0];
% for j = 1:length(RW.axis)
% quiver3(starts(:,1), starts(:,2), starts(:,3), axis(j,1), axis(j,2), axis(j,3))
% hold on
% end





