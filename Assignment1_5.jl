using Distributions,SpecialFunctions,Statistics,StatsBase,DelimitedFiles,HypothesisTests,Plots
pyplot()

N = 50
μ = 5
σ2 = 7
d = 0.1

samp = rand(Normal(μ,sqrt(σ2)),N)
samp_μ = mean(samp)
samp_σ2 = var(samp)

trial_μ = collect(1:d:10)
trial_σ2 = collect(1:d:10)
trial_σ = sqrt.(trial_σ2)

L = zeros(length(trial_μ),length(trial_σ2))

function pdfproduct(μ,σ,x)
    Π=1
    for i = 1:length(x)
        Π *= pdf(Normal(μ,σ),x[i])
    end
    return Π
end

for i in 1:length(trial_μ)
    for j in 1:length(trial_σ2)
        L[i,end+1-j] = pdfproduct(trial_μ[i],trial_σ[j],samp)
    end
end

# prior/length(prior)

prior = ones(length(trial_μ),length(trial_σ2))
post = L .* prior
P_data = sum(post/length(prior))

P = post/P_data

heatmap(trial_μ,trial_σ2,P)

# μ_hat = (1/N)*sum(samp)
#
# σ2_hat = (1/N)*sum((samp.-μ_hat).^2)
#
 ind = findmax(P)
#
# plot(P[:,ind[2][1]])
# vline!([μ_hat])
#
# plot(P[ind[2][2],:])
# vline!([σ2_hat])
