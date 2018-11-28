using Distributions,SpecialFunctions,Statistics,StatsBase,DelimitedFiles,HypothesisTests,Plots
pyplot()

N = 5
μ = 5
σ = 0.5
d = 0.1

samp = rand(Normal(μ,σ),N)

trial_μ = collect(1:d:10)
trial_σ = collect(0.1:d/10:1)
trial_σ2 = trial_σ.^2

L = zeros(length(trial_μ),length(trial_σ))

function pdfproduct(μ,σ,x)
    Π=1
    for i = 1:length(x)
        Π *= pdf(Normal(μ,σ),x[i])
    end
    return Π
end

for i in 1:length(trial_μ)
    for j in 1:length(trial_σ)
        L[i,j] = pdfproduct(trial_μ[i],trial_σ[j],samp)
    end
end

prior = ones(length(trial_μ),length(trial_σ))
post = L .* prior
P_data = sum(post/length(prior))

P = post/P_data

μ_hat = (1/N)*sum(samp)

σ2_hat = (1/N)*sum((samp.-μ_hat).^2)

ind = findmax(P)

trial_μ[41]
trial_μ[42]
trial_μ[43]

trial_σ2[42]
trial_σ2[43]
trial_σ2[44]

P2 = P.^2

plot(trial_σ2,P2[ind[2][1],:],label= "Marginal Distribution")
vline!([σ2_hat],label="σ̂²")
xlabel!("σ²")
ylabel!("Maximum Likelihood Estimation")
title!("σ² Marginal at μ̂")

savefig("sigma_marginal.png")

plot(trial_μ,P[:,ind[2][2]],label= "Marginal Distribution")
vline!([μ_hat],label="μ̂")
xlabel!("μ")
xticks!(0:1:10)
ylabel!("Maximum Likelihood Estimation")
title!("μ Marginal at σ̂²")

#savefig("mu_marginal.png")

heatmap(trial_σ,trial_μ,P,colorbar=false)
title!("Maximum Likelihood Estimation of a Normal Distribution")
xlabel!("σ")
xticks!(0:0.1:1)
ylabel!("μ")
yticks!(0:1:10)

#savefig("mle_2d.png")
