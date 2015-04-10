function data = map_data2node(f,d)
% newdata = map_data2node(elem,data)
%
% Brian Goodwin, 2014-06-24
%
% Maps data that exists on elements (edge,face,tet,etc.) to the nodes.
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
    [n,m] = size(f);
    j = repmat((1:n)',1,m);
    M = max(max(f));
    s1 = sparse(f,j,repmat(d,1,m),M,n);
    s2 = sparse(f,j,ones(n,m),M,n);
    data = full(sum(s1,2)./sum(s2,2));
end