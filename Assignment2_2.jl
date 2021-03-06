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
        covarp[j] += ((X[k]-μ)*(X[k_]-μ))

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
        covarn[j] += ((X_r[k]-μ)*(X_r[k_]-μ))

    end
    covarn[j] = covarn[j]/K
end

plot(covarn)

covarn = reverse(covarn)

covar = vcat(covarn[1:end-1],covarp)


## Theoretical Autocovariance
L = 4999 # [-L,L] is range for Autocovariance
ac_th = zeros(2*L+1)
for n in 1:2*L+1
    ac_th[n] = (σ_ϵ^2/(1-φ^2))*φ^abs(n-L-1)
end


plot(collect(-L:1:L), ac_th, title="Theoretical and Computational Autocovariance", xlabel="Value of n", ylabel="Autocovariance", label="Theoretical")

plot!(collect(-L:1:L),covar[t-L:t+L],label="Computational")
savefig("largeautocov.png")
