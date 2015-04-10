function data = map_data2element(f,d)
% newdata = map_data2node(elem,data)
%
% Brian Goodwin, 2014-06-24
%
% Maps data that exists on nodes (edge,face,tet,etc.) to the element by 
% linear interpolation.
%
% INPUTS:
% elem: element connections in columnwise form.
%         e.g.: edge = [1 2; 2 3; 3 4; ...]
% data: data on the elements in columnwise form. Vector or tensor data is
%        also supported.
%
% OUTPUTS:
% newdata: new data

% % Use for Debugging
% f = cat(2,(1:20)',(2:21)');
% d = rand(20,3);
% %

d = double(d);
f = double(f);
[M,N] = size(d);
if N>1
	tmp = cell(1,N);
	d = mat2cell(d,M,ones(N,1));
	if isPoolOpen
		parfor k = 1:N
			tmp{k} = map_data2node(f,d{k});
		end
	else
		for k = 1:N
			tmp{k} = map_data2node(f,d{k});
		end
	end
	data = cell2mat(tmp);
	return
else
    data = mean(d(f),2);
end