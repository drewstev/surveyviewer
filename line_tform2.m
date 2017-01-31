function [xyzout,dist,offset]=line_tform2(xyz,lnw,lind,tol,dcut,varargin)
%LINE_TFORM - orient x,y,z data along a line
%
%   INPUTS:
%   xyz  - m x 3 matrix of x, y, and z values
%   lnw  - linefile information as produced using
%          READLNW
%   lind - index in the linefile structure
%          of line to be used
%   tol  - offline tolerance (m)
%   dcut - max gap without a nan (distance, m)
%
%
%   OUTPUT is a m X 2 matrix with the first
%   column being along-line distance and the
%   second column elevation

if ~isempty(varargin)
    cut_along=1;
    extend=varargin{1};
else
    cut_along=0;
end
   
%trim ends
sidx=find(all(isfinite(xyz),2),1,'first');
eidx=find(all(isfinite(xyz),2),1,'last');
xyz=xyz(sidx:eidx,:);


%if line is not straight or not on a line
%use total distance traveled don't calculate offline
if lind==0 || numel(lnw(lind).x)>2
    xd=diff(xyz(:,1));
    yd=diff(xyz(:,2));
    dist=[0;cumsum(sqrt(xd.^2+yd.^2))];
    offset=NaN;
    xyzout=xyz;
else
   
    %remap points to along-line distance
    m=(lnw(lind).y(end)-lnw(lind).y(1))/...
        (lnw(lind).x(end)-lnw(lind).x(1));
    theta=atan(m);
    xt = xyz(:,1).*cos(theta) + xyz(:,2).*sin(theta);
    yt = -xyz(:,1).*sin(theta) + xyz(:,2).*cos(theta);
    
    xl=lnw(lind).x.*cos(theta) + ...
        lnw(lind).y.*sin(theta);
    yl=-lnw(lind).x.*sin(theta) + ...
        lnw(lind).y.*cos(theta);
    
    
    %calculate along line distance
    dist=xt-xl(1);
    
    
    
    
    %determine distance from line to points
    offset=yt-yl(1);
    
    
    %sort in along-line
    [dist,didx]=sort(dist);
    xyz=xyz(didx,:);
    offset=offset(didx);
    
    
    
    

   
    %see if there are large gaps
    %if so, insert a nan so that it plots nicely
    dd=abs(diff(dist));    
    gaps=find(dd>dcut);
    
    if ~isempty(gaps)
        xyz=insertrows(xyz,repmat(NaN,1,3),gaps);
        offset=insertrows(offset,NaN,gaps);
        dist=insertrows(dist,NaN,gaps);
    end
   
    

    
        
    
    %limit points according to distance offline
    gind=true(size(xyz,1),1);
    gind(abs(offset)>=tol)=0;
    
    %limit points to with a certain along line distance
    if cut_along
    line_dist=sort([0 xl(2)-xl(1)]);
    gind(dist<min(line_dist(1))-extend | dist>max(line_dist(2))+extend)=0;
    end
    
    
    xyzout=nan(size(xyz,1),3);
    xyzout(gind,:)=xyz(gind,:);
end

%%%%------------------------------------------------------------------
function [C,RA,RB] = insertrows(A,B,ind)
% INSERTROWS - Insert rows into a matrix at specific locations
%   C = INSERTROWS(A,B,IND) inserts the rows of matrix B into the matrix A at
%   the positions IND. Row k of matrix B will be inserted after position IND(k)
%   in the matrix A. If A is a N-by-X matrix and B is a M-by-X matrix, C will
%   be a (N+M)-by-X matrix. IND can contain non-integers.
%
%   If B is a 1-by-N matrix, B will be inserted for each insertion position
%   specified by IND. If IND is a single value, the whole matrix B will be
%   inserted at that position. If B is a single value, B is expanded to a row
%   vector. In all other cases, the number of elements in IND should be equal to
%   the number of rows in B, and the number of columns, planes etc should be the
%   same for both matrices A and B. 
%
%   Values of IND smaller than one will cause the corresponding rows to be
%   inserted in front of A. C = INSERTROWS(A,B) will simply append B to A.
%
%   If any of the inputs are empty, C will return A. If A is sparse, C will
%   be sparse as well. 
%
%   [C, RA, RB] = INSERTROWS(...) will return the row indices RA and RB for
%   which C corresponds to the rows of either A and B.
%
%   Examples:
%     % the size of A,B, and IND all match
%        C = insertrows(rand(5,2),zeros(2,2),[1.5 3]) 
%     % the row vector B is inserted twice
%        C = insertrows(ones(4,3),1:3,[1 Inf]) 
%     % matrix B is expanded to a row vector and inserted twice (as in 2)
%        C = insertrows(ones(5,3),999,[2 4])
%     % the whole matrix B is inserted once
%        C = insertrows(ones(5,3),zeros(2,3),2)
%     % additional output arguments
%        [c,ra,rb] = insertrows([1:4].',99,[0 3]) 
%        c.'     % -> [99 1 2 3 99 4] 
%        c(ra).' % -> [1 2 3 4] 
%        c(rb).' % -> [99 99] 
%
%   Using permute (or transpose) INSERTROWS can easily function to insert
%   columns, planes, etc:
%
%     % inserting columns, by using the transpose operator:
%        A = zeros(2,3) ; B = ones(2,4) ;
%        c = insertrows(A.', B.',[0 2 3 3]).'  % insert columns
%     % inserting other dimensions, by using permute:
%        A = ones(4,3,3) ; B = zeros(4,3,1) ; 
%        % set the dimension on which to operate in front
%        C = insertrows(permute(A,[3 1 2]), permute(B,[3 1 2]),1) ;
%        C = ipermute(C,[3 1 2]) 
%
%  See also HORZCAT, RESHAPE, CAT

% for Matlab R13
% version 2.0 (may 2008)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% 1.0, feb 2006 - created
% 2.0, may 2008 - incorporated some improvements after being selected as
% "Pick of the Week" by Jiro Doke, and reviews by Tim Davis & Brett:
%  - horizontal concatenation when two arguments are provided
%  - added example of how to insert columns
%  - mention behavior of sparse inputs
%  - changed "if nargout" to "if nargout>1" so that additional outputs are
%    only calculated when requested for

error(nargchk(2,3,nargin)) ;

if nargin==2,
    % just horizontal concatenation, suggested by Tim Davis
    ind = size(A,1) ;
end

% shortcut when any of the inputs are empty
if isempty(B) || isempty(ind),    
    C = A ;     
    if nargout > 1,
        RA = 1:size(A,1) ;
        RB = [] ;
    end
    return
end

sa = size(A) ;

% match the sizes of A, B
if numel(B)==1,
    % B has a single argument, expand to match A
    sb = [1 sa(2:end)] ;
    B = repmat(B,sb) ;
else
    % otherwise check for dimension errors
    if ndims(A) ~= ndims(B),
        error('insertrows:DimensionMismatch', ...
            'Both input matrices should have the same number of dimensions.') ;
    end
    sb = size(B) ;
    if ~all(sa(2:end) == sb(2:end)),
        error('insertrows:DimensionMismatch', ...
            'Both input matrices should have the same number of columns (and planes, etc).') ;
    end
end

ind = ind(:) ; % make as row vector
ni = length(ind) ;

% match the sizes of B and IND
if ni ~= sb(1),
    if ni==1 && sb(1) > 1,
        % expand IND
        ind = repmat(ind,sb(1),1) ;
    elseif (ni > 1) && (sb(1)==1),
        % expand B
        B = repmat(B,ni,1) ;
    else
        error('insertrows:InputMismatch',...
            'The number of rows to insert should equal the number of insertion positions.') ;
    end
end

sb = size(B) ;

% the actual work
% 1. concatenate matrices
C = [A ; B] ;
% 2. sort the respective indices, the first output of sort is ignored (by
% giving it the same name as the second output, one avoids an extra 
% large variable in memory)
[abi,abi] = sort([[1:sa(1)].' ; ind(:)]) ;
% 3. reshuffle the large matrix
C = C(abi,:) ;
% 4. reshape as A for nd matrices (nd>2)
if ndims(A) > 2,
    sc = sa ;
    sc(1) = sc(1)+sb(1) ;
    C = reshape(C,sc) ;
end

if nargout > 1,
    % additional outputs required
    R = [zeros(sa(1),1) ; ones(sb(1),1)] ;
    R = R(abi) ;
    RA = find(R==0) ;
    RB = find(R==1) ;
end







