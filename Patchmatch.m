function imgA  = Patchmatch(imgA,imgB,w)

[row, col, ~] = size(imgA);
offset = zeros(row-w*2,col-w*2,2);
alpha = 0.5;

for i = 1+w : row-w
    for j = 1+w : col-w
        indexr = randperm(row-w*2);
        indexc = randperm(col-w*2); 
        d1 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
            (indexr(1):indexr(1) +2*w,indexc(1):indexc(1) +2*w,:));
        d2 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
            (indexr(2):indexr(2) +2*w,indexc(2):indexc(2) +2*w,:));
        d3 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
            (indexr(3):indexr(3) +2*w,indexc(3):indexc(3) +2*w,:));
        id = find([d1,d2,d3] == min([d1,d2,d3]));  
        offset(i,j,:) = [indexr(id(1))+w,indexc(id(1))+w];
    end
end

for n = 1 : 5
    if mod(n,2)==1
        for i = 2+w : row-w
            for j = 2+w : col-w
                dis1 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
                    (offset(i,j,1)-w:offset(i,j,1)+w,offset(i,j,2)-w:offset(i,j,2)+w,:));
                dis2 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
                    (offset(i-1,j,1)-w:offset(i-1,j,1)+w,offset(i-1,j,2)-w:offset(i-1,j,2)+w,:));
                dis3 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
                    (offset(i,j-1,1)-w:offset(i,j-1,1)+w,offset(i,j-1,2)-w:offset(i,j-1,2)+w,:));
         
                dis = [dis1,dis3;dis2,inf];
                [ix,iy] = find(dis == min(min(dis)));
                offset(i,j,:) = offset(i+1-ix(1),j+1-iy(1),:);
                pos = [offset(i,j,1),offset(i,j,2)];
                width = min([pos(1)-w-1,pos(2)-w-1,row-pos(1)-w-1,col-pos(2)-w-1]);
                p = 0;
                posi = pos;
                while (width*alpha^p)>=1
                    R = 2* rand(1,2)-1;
                    posi = pos + (width*alpha^p)*R;
                    p = p + 1;
                end
                posi = round(posi);
                imgA(i,j,:) = imgB(posi(1),posi(2),:);
                offset(i,j,:)=[posi(1),posi(2)];
            end
        end
    else
        for i = row-w-1 : -1 : 1+w
            for j = col-w-1 : -1 :1+w 
                dis1 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
                    (offset(i,j,1)-w:offset(i,j,1)+w,offset(i,j,2)-w:offset(i,j,2)+w,:));
                dis2 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
                    (offset(i+1,j,1)-w:offset(i+1,j,1)+w,offset(i+1,j,2)-w:offset(i+1,j,2)+w,:));
                dis3 = SSD2(imgA(i-w:i+w,j-w:j+w,:),imgB...
                    (offset(i,j+1,1)-w:offset(i,j+1,1)+w,offset(i,j+1,2)-w:offset(i,j+1,2)+w,:));
                [dis,index] = min([dis1,dis2,dis3]);
                dis = [dis1,dis3;dis2,inf];
                [ix,iy] = find(dis == min(min(dis)));
                offset(i,j,:) = offset(i-1+ix(1),j-1+iy(1),:);
                pos = [offset(i,j,1),offset(i,j,2)];
                width = min([pos(1)-w-1,pos(2)-w-1,row-pos(1)-w-1,col-pos(2)-w-1]);
                p = 0;
                posi = pos;
                while (width*alpha^p)>=1
                    R = 2* rand(1,2)-1;
                    posi = pos + width*alpha^p*R;
                    p = p + 1;
                end
                posi = round(posi);
                imgA(i,j,:) = imgB(posi(1),posi(2),:);
                offset(i,j,:)=[posi(1),posi(2)];
            end            
        end
    end
    imwrite (imgA,['part2\resultw=',num2str(w),'\iteration',num2str(n),'.png']);
end
end