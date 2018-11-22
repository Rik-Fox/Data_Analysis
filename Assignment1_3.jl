using Distributions,SpecialFunctions,Statistics,HypothesisTests
using StatsBase,Plots,Random
pyplot()

N = 10
n = collect(2:1:N)
ν = n.-1

x=-5:0.1:5
dist = zeros(N)

for i=1:N-1
    dist[i] = pdf.(TDist(ν[i]),n)
end

plot(x,dist[2])
