function [thres_img, level] = my_threshold(img, type)
% Find Threshold 
% img       : GrayScale Image     dimension (height x width)
% type      : kinds of threshold  {'within', 'between'}
% thres_img : threshold image     dimension (height x width)
% level     : threshold value     type( uint8 )
%thres_img = img;
    [x,y] = size(img);
    list_k = [];
    for k= 1:256
        until_k = img(img<=k-1);
        if isempty(until_k)
            until_k=[0,0,0];
        end
        from_k = img(img>k-1);
        if isempty(from_k)
            from_k=[0,0,0];
        end
        uk =var(double(until_k));
        fk = var(double(from_k));
        list_k(k) = uk+fk;
    end 
    real_k = find(list_k==min(list_k));
if strcmp(type, 'within')
    % Within variance
    % Fill here
    until_k = img<=real_k;
    mask_img = img>real_k;
    within_res = double(img).*double(mask_img);
    imshow(double(img)-within_res);
else
    % Between variance
    % Fill here   
    q1t = zeros(size(img));
    for q1i = 1:real_k
        q1t= q1t+ q1i*double(img==q1i).*double(img);
    end
    
    q2t = zeros(size(img));
    for q2i = real_k+1:255
        q2t= q2t+q2i*double((img==q2i).*double(img));
    end
    q1 = double(img<=real_k).*double(img);
    q2 = double(img>real_k).*double(img);
    m1 = q1t./q1;
    m1(isnan(m1))=0;
    
    m2 = q2t./q2;
    m2(isnan(m2))=0;
    
    mg = q1.*m1+q2.*m2;
    Between = uint8(q1.*((m1-mg)/(x*y)).^2+ q2.*((m2-mg)/(x*y)).^2);
    imshow(Between);
    
end


end
