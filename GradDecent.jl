using Plots,Statistics,Distributions
pyplot()
n = 10

t = 2 .*collect(1:10) .+ 1 .+ 0.02*randn(n)

X = [t ones(n)]

T = copy(t)

w = [0;0]

function pred(X,w)

    P = X*w

    return P
end

function weightgrad(X,n,P,T)

    Δ = P-T
    C_grad = (1/n).*(X')*Δ

    return C_grad
end

# X = [2 3;3 1]
#
# T = [1,2]
#
# P = pred(X,w)
# weight_grad = weightgrad(X,n,P,T)
# w -= α*weight_grad


function cost(P,T,n)

    cost1 = (1/(2*n))*sum((P.-T).^2)
    return cost1
end
α = 0.1

function myfit(w,X,P,T,n)
    for i=1:100
        P = pred(X,w)
        weight_grad = weightgrad(X,n,P,T)
        w -= α*weight_grad
    end
    return w
end

w = myfit(w,X,P,T,n)

x = collect(0:0.1:1)

linfit = w[1]*x .+ w[2]

scatter(x,t)
plot!(x,linfit)
