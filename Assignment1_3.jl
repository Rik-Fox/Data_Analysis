using Distributions,SpecialFunctions,Statistics,HypothesisTests
using StatsBase,Plots,Random
pyplot()

N = 10
n = collect(2:1:N)
ν = n.-1

x=-5:0.1:5
dist = zeros(N)

for i=1:N
    dist[i] = fit(TDist(ν[i]),x)
end

plot(x,pdf.(dist[2],x))
