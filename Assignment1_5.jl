using Distributions,SpecialFunctions,Statistics,StatsBase,DelimitedFiles,HypothesisTests,Plots
pyplot()

N = 5
μ = 50
σ2 = 9
d = 0.1

samp = rand(Normal(μ,sqrt(σ2)),N)
samp_μ = mean(samp)
samp_σ2 = var(samp)

low = samp_μ - (1.96*sqrt(samp_σ2))
high = samp_μ + (1.96*sqrt(samp_σ2))

trial_μ = collect(low:d:high)
trial_σ2 = collect(0.1:d:2*samp_σ2)
trial_σ = sqrt.(trial_σ2)

L = zeros(length(trial_σ2),length(trial_μ))

function pdfproduct(μ,σ,x)
    Π=1
    for i = 1:length(x)
        Π *= pdf(Normal(μ,σ),x[i])
    end
    return Π
end

for i in 1:length(trial_μ)
    for j in 1:length(trial_σ2)
        L[end+1-j,i] = pdfproduct(trial_μ[i],trial_σ[j],samp)
    end
end

# prior/length(prior)

prior = ones(length(trial_σ2),length(trial_μ))
post = L .* prior
P_data = sum(post/length(prior))

P = post/P_data

heatmap(trial_μ,trial_σ2,P)

#Using posterior as prior

# prior2=posterior
# posterior2=L .* prior2 /prob_of_data
# heatmap(meanAxis,varAxis,posterior2)
#
# prior3=posterior2
# posterior3=L .* prior3 /prob_of_data
# heatmap(meanAxis,varAxis,posterior3)
