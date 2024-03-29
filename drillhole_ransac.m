
clear
%%%%% segmentation %%%%%
foto = imread('drill-test_nahe.jpg');
img = rgb2gray(foto);
img = im2bw(img,0.3);
stats = regionprops(~img,'all')
holes = cat(1, stats.Centroid);

%%%%% input data %%%%%
%in = [-13.9700 1.2700;-13.9700 11.4300;-16.5100 1.2700;-16.5100 11.4300;-2.5400 1.2700  ;-2.5400 3.8100  ;-2.5400 6.3500  ;-2.5400 8.8900  ;-10.1600 1.2700 ;-10.1600 3.8100 ;-10.1600 6.3500 ;-10.1600 8.8900]
in = [3 0;6 0;5 5;10 10;-1 -1;0 0;0 10];
num = size(in,1);
in(:,1) = -in(:,1);

size_dist_image = [800 600];
img2 = ones(size_dist_image(2),size_dist_image(1));
max_dist = sqrt(size_dist_image(1)^2+size_dist_image(2)^2);

holes_norm(:,1) = holes(:,1) / 800 * size_dist_image(1);
holes_norm(:,2) = holes(:,2) / 600 * size_dist_image(2);

%for i=1:size_dist_image(1)*size_dist_image(2)
%    y = mod(i-1,size_dist_image(2))+1;
%    x = round((i-1) / size_dist_image(2))+1;
%    c = repmat([x y],size(holes_norm,1),1);
%   d = sqrt(sum((c - holes_norm).^2,2));
%    img2(i) = min(img2(i), min(d) / max_dist);
%end

best_distance = 9999999999;
best_t = [];


figure, imshow(foto);
hold on;

combinations = combnk(1:size(holes,1),2);
combinations = [combinations; fliplr(combinations)];
for i=1:size(combinations)
    idx1 = combinations(i,1);
    idx2 = combinations(i,2);

    pointA = holes(idx1,:); %31
    pointB = holes(idx2,:); %39
    t = coordTrafo(pointA,pointB,in);
    tx = (t(:,1)-1) / 800;
    ty = (t(:,2)-1) / 600;
    
    if(any(tx < 0) || any(ty < 0) || any(tx >= 1) || any(ty >= 1))
        continue;
    end

    distance = 0;
    y = ty * size_dist_image(2) + 0.5;
    x = tx * size_dist_image(1) + 0.5;
    h = holes;
    for j=1:size(t,1)
        c = repmat([x(j) y(j)],size(h,1),1);
        d = sum((c - h).^2,2);
        [dist, idx] = min(d);
        distance = distance + dist;
        
        h(idx,:) = [];  % inc performance by reducing possible vectors
        if(distance > best_distance) % early termination
            break;
        end
    end
    
    if(distance < best_distance)
        best_distance = distance;
        best_t = t;
    end
end

scatter(holes(:,1),holes(:,2),'g');
scatter(best_t(:,1), best_t(:,2),75,'r+');

hold off;   

%figure, imshow(img2);
