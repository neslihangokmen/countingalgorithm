I=imread('bird 3.bmp');
dim = size(I);
I = rgb2gray(I);
% histgram of input image
his = imhist(I);
leng=length(his);
para = zeros(1,leng);
for k = 2:leng-1
    % intensity of class 1
    class1 = his(1:k);
    ind = (class1==0);
    class1 = class1+ind;
    clear ind
    % intensity of class 2
    class2 = his(k+1:end);
    ind = (class2==0);
    class2 = class2+ind;
    clear ind
    % probability distribution of class 1
    P1 = class1/(dim(1,1)*dim(1,2));
    % probability distribution of class 2
    P2 = class2/(dim(1,1)*dim(1,2));
    % parameters to decide threshold
    par1 = log2(sum(P1));
    par2 = log2(sum(P2));
    logp1 = log2(P1);
    logp2 = log2(P2);
    par3 = -sum(P1.*logp1)/sum(P1);
    par4 = -sum(P2.*logp2)/sum(P2);
    % parameter which has to be maximized
    para(1,k) = abs(par1+par2+par3+par4);
    clear class1 class2 logp1 logp2
end
% set threshold
[maxv,row] = max(para);
t = row-1;
% segment image
I = (I>=t);
I=~I;
imshow(I);
%Structuring element
B=[0 1 0 ; 1 1 1 ; 0 1 0];
%B=strel('square',1);
A=imerode(I,B);
%C=strel('disk',10);
C=[0 0 0 0 1 1 0 0 0 0 ; 0 0 0 1 1 1 1 0 0 0  ; 0 1 1 1 1 1 1 1 0 0; 1 1 1 1 1 1 1 1 1 1 ; 0 1 1 1 1 1 1 1 0 0; 0 0 0 1 1 1 1 0 0 0 ; 0 0 0 0 1 1 0 0 0 0];%
%Find a non-zero element's position.
p=find(A==1);
p=p(1);
Label=zeros([size(A,1) size(A,2)]);
N=0;
%Labeling each component
while(~isempty(p))
    N=N+1;
    p=p(1);
X=false([size(A,1) size(A,2)]);
X(p)=1;
Y=A&imdilate(X,C);
while(~isequal(X,Y))
    X=Y;
    Y=A&imdilate(X,C);
end
Pos=find(Y==1);
A(Pos)=0;
%Label the components
Label(Pos)=N;
p=find(A==1);
end
Total=sprintf('Number of birds:%d',N);
display(Total);
%Differentiate each component with a specific color
RGBIm=zeros([size(Label,1) size(Label,2) 3]);
R=zeros([size(Label,1) size(Label,2)]);
G=zeros([size(Label,1) size(Label,2)]);
B=zeros([size(Label,1) size(Label,2)]);
U=64;
V=255;
W=128;
for i=1:N
    Pos=find(Label==i);
    R(Pos)=mod(i,2)*V;
    G(Pos)=mod(i,5)*U;
    B(Pos)=mod(i,3)*W;
 end
RGBIm(:,:,1)=R;
RGBIm(:,:,2)=G;
RGBIm(:,:,3)=B;
RGBIm=uint8(RGBIm);
figure,imshow(RGBIm);title('Labelled Components');
 


