using Distributions,SpecialFunctions,Statistics,HypothesisTests
using StatsBase,Plots,Random
pyplot()

N=10000
μ = 5
σ = 1
samp = (randn(N).*σ) .+μ
histogram(samp,bins=100)

trial_μ = collect(1:0.1:10)
trial_σ = collect(1:0.1:10)

low5 = zeros(length(trial_μ),length(trial_σ))
high5 = zeros(length(trial_μ),length(trial_σ))

for i=1:length(trial_σ)
low5[:,i] .= invlogcdf.(Normal.(trial_μ,trial_σ[i]),log(0.025))
high5[:,i] .= invlogcdf.(Normal.(trial_μ,trial_σ[i]),log(0.975))
end

μ_L = trial_μ.-mean(samp)
σ2_L = (trial_σ.^2).-((samp.^2).-(mean(samp)^2))

map5 = abs.(high5).-abs.(low5)

heatmap(map5)

low1 = zeros(length(trial_μ),length(trial_σ))
high1 = zeros(length(trial_μ),length(trial_σ))

low1  .= invlogcdf.(Normal.(trial_μ,trial_σ),log(0.005))
high1 .= invlogcdf.(Normal.(trial_μ,trial_σ),log(0.995))
