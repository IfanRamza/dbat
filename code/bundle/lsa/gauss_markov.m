function [x,code,n,f,J,T]=gauss_markov(resFun,x0,maxIter,convTol,params)
%GAUSS_MARKOV Gauss-Markov least squares adjustment algorithm.
%
%   [X,CODE,I]=GAUSS_MARKOV(RES,X0,N,TOL,PARAMS) runs the Gauss-Markov least
%   squares adjustment algorithm on the problem with residual function RES
%   and with initial values X0. A maximum of N iterations are allowed and
%   the convergence tolerance is TOL. The final estimate is returned in X.
%   The number of iteration I and a success code (0 - OK, -1 - too many
%   iterations) are also returned.
%
%   [X,CODE,I,F,J]=... also returns the final estimates of the residual
%   vector F and jacobian matrix J.
%
%   [X,CODE,I,F,J,T]=... returns the iteration trace as successive columns
%   in T.
%
%   The function RES is assumed to return the residual function and its
%   jacobian when called [F,J]=feval(RES,X0,PARAMS{:}), where the cell array
%   PARAMS contains any extra parameters for the residual function.
%
%See also: BUNDLE, GAUSS_NEWTON_ARMIJO, LEVENBERG_MARQUARDT,
%   LEVENBERG_MARQUARDT_POWELL.

% $Id$

% Initialize current estimate and iteration trace.
x=x0;

if nargout>6
    % Pre-allocate fixed block if trace is asked for.
    blockSize=50;
    T=nan(length(x),min(blockSize,maxIter+1));
    % Enter x0 as first column.
    T(:,1)=x0;
end

n=0;

% OK until proven otherwise.
code=0;

while true
    % Calculate residual and jacobian at current point.
    [f,J]=feval(resFun,x,params{:});

    % Solve normal equations.
    p=(J'*J)\-(J'*f);

    % Terminate if angle between projected residual is smaller than
    % threshold. Warning! This test may be very strict on synthetic data
    % where norm(f) is close to zero at the solution.
    if norm(J*p)<=tol*norm(f)
        % Converged.
        break;
    end
    
    % Update iteration count.
    n=n+1;
    
    % Terminate with error code if too many iterations.
    if n>maxIter
        code=-1; % Too many iterations.
        break;
    end

    % Update estimate.
    x=x+p;

    if nargout>6
        % Store iteration trace.
        if n+1>size(T,2)
            % Expand by blocksize if needed.
            T=[T,nan(length(x),blockSize)];
        end
        T(n+1,:)=x;
    end
end