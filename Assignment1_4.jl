using Distributions,SpecialFunctions,Statistics,HypothesisTests
using StatsBase,Plots,Random,LinearAlgebra
pyplot()

N=100
μ = 2
σ = 0.5
samp = (randn(N).*σ) .+μ

histogram(samp,bins=100)
xlabel!("X")

dμ = 0.1
dσ = dμ/10

trial_μ = collect(-4.9:dμ:5)
trial_σ = collect(0.01:dσ:1)

big_i = length(trial_μ)
J = length(trial_σ)


L = zeros(big_i,J)

l = 1.0

for i=1:big_i
      for j=1:J
            for k=1:length(samp)
                  l = l*(1/sqrt(2*pi*trial_σ[j].^2))*exp(-((samp[k]-trial_μ[i])^2)/2*trial_σ[j].^2)
            end

            L[i,j]= l
            l=1
      end
end

ind = findmax(L)

heatmap(trial_μ,trial_σ,L)
xticks!(trial_σ)



predict_μ = trial_μ[ind[2][1]]
predict_σ = trial_σ[ind[2][2]]
trial_σ[ind[2][3]]
