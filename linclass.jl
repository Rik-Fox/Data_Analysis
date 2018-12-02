using Plots,Statistics,Distributions
pyplot()

func(z) = 1 ./(1 .+exp.(-z))

ns=50
m,c=1.0,0.1

# create the data
X=2*(rand(ns,2).-0.5)
T=1.0*(X[:,2].>(m*X[:,1].+c))

# add some scatter (optional)
sig=0.00
X=X.+sig*randn(ns,2)

Xb=[X ones(ns)];

w = [1;1;1]

function pred(X,w)
    Z = X*w
    P = func(Z)
    return P
end

P = pred(Xb,w)

function weightgrad(X,n,P,T)
    Δ = P-T
    C_grad = (1/n).*(X')*Δ
    return C_grad
end

function cost(P,T,n)
    cost1 = (1/(2*n))*sum((P.-T).^2)
    return cost1
end

α =0.1

function myfit(w,X,P,T,n)
    for i=1:100
        P = pred(X,w)
        weight_grad = weightgrad(X,n,P,T)
        w -= α*weight_grad
    end
    return w
end

w = myfit(w,Xb,P,T,ns)

x=[collect(-1:0.1:1),collect(-1:0.1:1)]
y=m*x.+c

theme(:wong)

scatter(X[:,1],X[:,2], zcolor=T, colorbar=false)

plot!(x, y)

logisfit = func((w[1])*x[1] .+ (w[2])*x[2] .+ w[3])
logisfit0 = func(0*x[1] .+ 0*x[2])
z = (w[1]/w[2]).*x .+ w[3]

plot(x, logisfit0)
