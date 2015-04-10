%Takes the variable sub from coilOrient and converts it into vectors
%representing stimulation and wand orientation.

function [sub_transVecStim sub_transVecWand] = transVec(TestVec, sub)

    for i = 1: length(sub.trans)
        %rotate
        sub_transVecStim.data(:,i)=TestVec.data(1,:)* sub.rot(:,:,i);
        sub_transVecWand.data(:,i)=TestVec.data(2,:)* sub.rot(:,:,i);

        %translate
        sub_transVecStim.node(:,i)=sub.pos(:,i)'/1000;
        sub_transVecWand.node(:,i)=sub.pos(:,i)'/1000;
    end
        %transpose 
        sub_transVecStim.data=sub_transVecStim.data';
        sub_transVecWand.data=sub_transVecWand.data';
        sub_transVecStim.node= sub_transVecStim.node';
        sub_transVecWand.node=sub_transVecWand.node';
end
    



        