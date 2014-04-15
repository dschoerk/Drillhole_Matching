

function [ t ] = coordTrafo(pointA, pointB, in)
    t = in;
    num = size(in,1);
    ab_distance = sqrt(sum((pointA-pointB).^2));
    in_distance = sqrt(sum((t(1,:)-t(2,:)).^2));
    scale = ab_distance / in_distance; 
    t = t * scale; % scale
    t = t + repmat(pointA-t(1,:) ,num,1); % translate
    tmp1 = pointB - pointA;
    tmp2 = t(2,:) - pointA;
    angle = atan2(tmp1(2),tmp1(1)) - atan2(tmp2(2),tmp2(1));
    rotmat = [cos(angle) -sin(angle); sin(angle) cos(angle)]'; 
    sub = t(1,:);
    t = t - repmat(sub,num,1);
    t = t*rotmat; % rotate
    t = t + repmat(sub,num,1);
end