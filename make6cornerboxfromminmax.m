function box = make6cornerboxfromminmax(mn,mx)
% box = make6cornerboxfromminmax(mn,mx)
%
% Brian Goodwin 2014-09-18
%
% Given the min and max bounding corners of a box, the output is the 6
% corners of the box.

box = [
    mn
    mx(1),mn(2:3)
    mn(1),mx(2),mn(3)
    mx
    mn(1),mx(2:3)
    mx(1),mn(2),mx(3)
    ];