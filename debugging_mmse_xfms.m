clear
close all
clc

p = rand(3,3)*4;

N = 10;

c = zeros(N*3,1);
c(1:3:end) = linspace(0,1,N);
c(2:3:end) = linspace(0,1,N);
c(3:3:end) = linspace(0,1,N);

m = cell(N,1);
pm = cell(N,1);

for k = 1:N%-1
    m{k} = makehgtform('axisrotate',rand(3,1),rand*pi,'translate',rand(1,3));
    pm{k} = xfm3d(p,m{k},1);
end

% m{N} = makehgtform('axisrotate',[-rand,-rand,rand],rand*pi,'translate',rand(1,3)*4);
% m{N} = m{N};
% pm{N} = xfm3d(p,m{N},1);

pm = cell2mat(pm);

tmp = cell(N,1);
for k = 1:N
    tmp{k} = m{k}(1:3,1:3);
end

q = qGetQ(tmp);
new = mmse_xfms(m);
newp = xfm3d(p,new,1);

qfin = qGetQ(new(1:3,1:3));

disp('MMSE Quaternion:')
disp(qfin)
disp('Input Quaternions from rotation matrices:')
disp(q)
disp('"Mean Quaternion:')
disp(mean(q)./norm(mean(q)));

%% Validation

% 3 Point Validation
figure
scatter3(p(:,1),p(:,2),p(:,3),100,[.5 .5 .5],'filled')
hold on
scatter3(pm(:,1),pm(:,2),pm(:,3),40,get_color_for_colorbar(c),'filled')
scatter3(newp(:,1),newp(:,2),newp(:,3),200,'filled','k')
axis equal
hold off

% Quiver Validation
figure
quiver3(0,0,0,p(1,1),p(1,2),p(1,3),'color',[.5 .5 .5],'linewidth',3)
hold on
for k = 1:3:N*3
    quiver3(0,0,0,pm(k,1),pm(k,2),pm(k,3),'color',get_color_for_colorbar(c(k,:)),'linewidth',2)
end
quiver3(0,0,0,newp(1,1),newp(1,2),newp(1,3),'color','k','linewidth',3)
axis equal
hold off