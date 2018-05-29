function Dis = SSD2(img1,img2)

for i = 1 : size(img1,3)
    i1 = img1(:,:,i);
    i2 = img2(:,:,i);
    
    if i == 1
        Dis = sum(sum((i1-i2).^2));
    else
        Dis = Dis + sum(sum((i1-i2).^2));
    end
end
end