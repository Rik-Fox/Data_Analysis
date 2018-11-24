using Distributions,SpecialFunctions,Statistics,StatsBase,DelimitedFiles,HypothesisTests,Plots
pyplot()

N = 5
μ = 5
σ = 0.3
d = 0.1

samp = rand(Normal(μ,σ),N)

trial_μ = collect(1:d:10)
trial_σ = collect(0.1:d/10:1)

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

# prior/length(prior)

prior = ones(length(trial_μ),length(trial_σ))
post = L .* prior
P_data = sum(post/length(prior))

P = post/P_data

μ_hat = (1/N)*sum(samp)

σ_hat = sqrt.((1/N)*sum((samp.-μ_hat).^2))

ind = findmax(P)

plot(trial_σ,P[ind[2][1],:])
vline!([σ_hat])

plot(trial_μ,P[:,ind[2][2]])
vline!([μ_hat])

heatmap(trial_σ,trial_μ,P)
