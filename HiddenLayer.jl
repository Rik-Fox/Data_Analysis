using Plots, Random, Statistics
pyplot()
theme(:sand)

ns = 400

cx1,cy1,r1=0.3,0.3,0.3
cx2,cy2,r2=-0.4,-0.4,0.3

# create the data
X = 2*(rand(ns,2).-0.5)
C1 = (X[:,1].-cx1).^2 .+(X[:,2].-cy1).^2 .<r1^2
C2 = (X[:,1].-cx2).^2 .+(X[:,2].-cy2).^2 .<r2^2
T = 1.0*(C1.|C2)

scatter(X[:,1],X[:,2],zcolor=T,colorbar=false)

func(z) = 1 ./(1 .+exp.(-z))

Xb = hcat(X,ones(ns))

α = 1

function pred(X,w)
    Z = X*w
    P = func(Z)
    return P
end

nh = 8

w = ones(3,nh)

v = ones(nh+1)

function weightgradv(X,n,P,T)

    Δ = P-T
    C_grad = (1/n).*(X')*Δ

    return C_grad
end

function weightgradw(X,n,P,T,v,h)

    Δ = P-T.*((h.*(1 .-h))*v)
    C_grad = (1/n).*(X')*Δ

    return C_grad
end

function myhiddenlayer(X,w,h,hb,v,ns,nh,P,T,α)
    for i=1:10000

        v_weight = weightgradv(hb,nh,P,T)

        v -= α*v_weight

        w_weight = weightgradw(X,ns,P,T,v[1:end-1],h)

        w .-= α*w_weight

        h = pred(X,w)

        hb = hcat(h,ones(ns))

        P = pred(hb,v)
    end

    return w,v,P

end

w1,v1,P = myhiddenlayer(Xb,w,h,hb,v,ns,nh,P,T,α)

P = Int.(P.<0.5)

plot(scatter(X[:,1],X[:,2],zcolor=T,colorbar=false),scatter(X[:,1],X[:,2],zcolor=P,colorbar=false))

#scatter(X[:,1],X[:,2],zcolor=T,colorbar=false)
