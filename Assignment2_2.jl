using Plots, Statistics, Distributions,Random
pyplot()

t = 5000
c = 1
φ = 0.5
σ_ϵ = 2

X = zeros(t)
ϵ = rand(Normal(0,σ_ϵ),t)

X[1] = sqrt(2)/10 + ϵ[1]

for i=2:t

X[i]= c + φ*X[i-1] + ϵ[i]
end

plot(X)

μ = mean(X)
σ = var(X)

μ_th = c/(1-φ)
σ_th = (σ_ϵ^2)/(1-φ^2)

covarp = zeros(t)
covarp[1] = var(X)

for j =2:t
    K = (t-j-1)
    for k=1:K

        n = j-1
        k_= k+n
        covarp[j] += (φ^(n))*((X[k]-μ)*(X[k_]-μ))

    end
    covarp[j] = covarp[j]/K
end

covarn = zeros(t)
X_r = reverse(X)

for j =2:t
    K = (t-j-1)
    for k=1:K

        n = j-1
        k_= k+n
        covarn[j] += (φ^(n))*((X_r[k]-μ)*(X_r[k_]-μ))

    end
    covarn[j] = covarn[j]/K
end

plot(covarn)

covarn = reverse(covarn)

covar = vcat(covarn[1:end-1],covarp)

plot(collect(-10:1:10),covar[4990:5010])
xaxis!(-10:10)
