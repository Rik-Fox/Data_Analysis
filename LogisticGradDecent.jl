using Plots,Statistics,Distributions

n = 10

x = rand(n)

t = 2 .* x .+ 1 .+ 0.02*randn(n)

X = [x ones(n)]

T = copy(t)

w = [1;1]

function pred(X,w)
    P = X*w
    return P
end

P = pred(X,w)

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

w = myfit(w,X,P,T,n)

x_test = collect(LinRange(0, 1., 11))

linfit = w[1]*x_test .+ w[2]

scatter(x, t)
plot!(x_test, linfit)
