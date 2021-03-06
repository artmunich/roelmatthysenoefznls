% Nonlinear Systems - 2012
% Example Script - Numerical Continuation - Bead on a tilted wire
%   Exercise: 1.4.1
%   System:   Simplified equilibrium equation:
%             u' = -0.5*u^3 + r*u + h = 0
%             see myfunbead.m in Systems folder
%!! Case:     h is used as a parameter, r is fixed
%
%!! Goal:     Draw solution branches using h as parameter
%             for different values of r.
%!! How?      This script has been written based on a first analysis
%             of the problem using MAPLE (see file on TOLEDO)
%!! Use:      This script can be used to draw solution branches
%             for r = 0, r > 0, r < 0
%
%!! More details about MATCONT routines:
%   see CL MATCONT manual
%       Topic: Equilibrium continuation: p. 34-40

% Version: March, 2012
% nico.scheerlinck@cs.kuleuven.be

clear all
global cds
rs=[-1:1];
size=6;



for i=1:numel(rs)
    r=rs(i);
    opt=contset;
    
    % ---------------------------------------------------
    % PROGRAM AREA
    % OPTIONS: details about options see p. 18-20
    opt=contset(opt,'MaxNumPoints',100);
    opt=contset(opt,'Singularities',1);
    opt=contset(opt,'Eigenvalues',1);
    % Set initial parameter values p ==> p = [r;h]
    r  = rs(i);     % Note: r is fixed to this value
    h  = 0;    % Note: h is the (active) parameter
    u0 = -1.5;     % find fixed point
    p0 = [r;h]; % r and h are set by the user
    ap = 2;     % Note: index of continuation parameter = 2
    % Initialisation Step
    [x0,v0] = init_EP_EP(@myfunbead,u0,p0,ap);
    % Compute forward
    opt=contset(opt,'Backward',0);
    [x1,v1,s1,h1,f1] = cont(@equilibrium,x0,[],opt);
    % x1(1,:) ==> value fixed point
    % x1(2,:) ==> corresponding value for parameter h (active parameter)
    % f1      ==> eigenvalues jacobian (if option is set)
    % plot u versus h
    figure(1);clf;hold on
    cpl(x1,v1,s1,[2 1]);
    % Compute backward
    %opt=contset(opt,'Backward',1);
    %[x2,v2,s2,h2,f2] = cont(@equilibrium,x0,[],opt);
    % x2(1,:) ==> value fixed point
    % x2(2,:) ==> corresponding value for parameter h (active parameter)
    % f2      ==> eigenvalues jacobian (if option is set)
    % plot u versus h
    %  cpl(x2,v2,s2,[2 1]);
    %  xlabel('h');ylabel('u')
    %  title(['r = ' num2str(r)])
    %  grid on
    % ---------------------------------------------------------------------
    
    % ---------------------------------------------------------------------
    % POST PROCESSING AREA
    %  x = [x1 x2]; % forward and backward results
    %  f = [f1 f2]; % eigenvalues jacobian
    %  u = x(1,:);  % fixed points
    %  h = x(2,:);  % active parameter
    
    x = [x1];    % forward results
    f = [f1];    % eigenvalues jacobian
    u = x(1,:);  % fixed points
    h = x(2,:);  % active parameter
    
    % Stability analysis plot
    % Goal: Visualisation of stable and unstable branches
    figure(2);clf;hold on
    pos = find(sign(f) == 1);
    nul = find(sign(f) == 0);
    neg = find(sign(f) == -1);
    
    if ~isempty(pos)
        plot(h(pos),u(pos),'r.','linewidth',2)
    end
    if ~isempty(nul)
        plot(h(nul),u(nul),'k.','linewidth',2)
    end
    if ~isempty(neg)
        plot(h(neg),u(neg),'b.','linewidth',2)
    end
    xlabel('h');ylabel('u')
    title(['r = ' num2str(r)])
    grid on
    
    % The code below has been tested for r=1 only!
    % For other values of r ( r<=0 or r>0) the code below might not work.
    % In that case, find out why, and adjust the code to your needs.
    
    if r > 0
        figure;hold on;
        % plot stable path
        line(x1(2,1:s1(2).index),x1(1,1:s1(2).index),'linestyle','-','color','b','linewidth',2);
        % plot first LP
        plot(x1(2,s1(2).index),x1(1,s1(2).index),'r.','linewidth',3,'MarkerSize',20);
        text(x1(2,s1(2).index),x1(1,s1(2).index),['   ' s1(2).label])
        % plot UNstable path
        line(x1(2,s1(2).index:s1(3).index),x1(1,s1(2).index:s1(3).index),'linestyle','--','color','b','linewidth',2);
        % plot second LP
        plot(x1(2,s1(3).index),x1(1,s1(3).index),'r.','linewidth',3,'MarkerSize',20);
        text(x1(2,s1(3).index),x1(1,s1(3).index),['   ' s1(3).label])
        % plot stable path
        line(x1(2,s1(3).index:end),x1(1,s1(3).index:end),'linestyle','-','color','b','linewidth',2);
        axis([-1 1 -1.5 1.5]);axis square;
        xlabel('h');ylabel('u')
        grid on
        saveEps('../verslag/img/ex1/bif141rpos.eps',6,6)
        
    end
    if r == 0
        figure;hold on;
        % plot stable path
        line(x1(2,1:end),x1(1,1:end),'linestyle','-','color','b','linewidth',2);
        axis([-1 1 -1.5 1.5]);axis square;
        xlabel('h');ylabel('u')
        grid on
        saveEps('../verslag/img/ex1/bif141rnul.eps',6,6)
        
    end
    if r < 0
        figure;hold on;
        % plot stable path
        line(x1(2,1:end),x1(1,1:end),'linestyle','-','color','b','linewidth',2);
        axis([-1 1 -1.5 1.5]);axis square;
        xlabel('h');ylabel('u')
        grid on
        saveEps('../verslag/img/ex1/bif141rneg.eps',6,6)
    end
end