clear;
imgA = im2double(imread('part2\11.png'));
imgB = im2double(imread('part2\12.png'));
w = 1;
if exist(['part2\resultw=',num2str(w)],'dir') == 0
    mkdir(['part2\resultw=',num2str(w)]);
end
imgA = Patchmatch(imgA,imgB,w);
