% make_edge_file_for_scirun.m
% 
% 2014-02-25 Brian Goodwin
%
% Makes the edge file for the following pts file (in weird format
% from Klaus). The approach of this code can easily be replicated
% for more practical use.

load /Users/1773goodwib/Documents/Misc_MatlabWork/pntsNoEmpties.mat

pt = pntsNoEmpties;
[N,M] = size(pt);
x = pt(:,1:3:end-2);
y = pt(:,2:3:end-1);
z = pt(:,3:3:end);

n = sum(double(logical(x)),2);

x = reshape(x',[],1);
y = reshape(y',[],1);
z = reshape(z',[],1);

h = logical(x);
x = x(h);
y = y(h);
z = z(h);
pts = [x,y,z];

edge = [];
endnum = -1;
for k = 1:length(n)
    startnum = endnum+1;
    endnum = startnum+n(k)-1;
    new = (startnum:endnum-1)';
    edge = cat(1,edge,[new,new+1]);
end

dsi.node = pts;
dsi.edge = edge+1;

save('/Users/1773goodwib/Documents/Misc_MatlabWork/dsi.mat','dsi','-v7')

% dlmwrite('/Users/1773goodwib/Documents/Misc_MatlabWork/dsi.pts',pts,'delimiter','\t','precision','%8.3f');
% dlmwrite('/Users/1773goodwib/Documents/Misc_MatlabWork/dsi.edge',edge,'delimiter',' ');