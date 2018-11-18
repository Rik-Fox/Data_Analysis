using Distributions,SpecialFunctions,Statistics,DataFrames
using HypothesisTests,Plots,Random,DelimitedFiles,Pkg
using StatsBase
pyplot()

Data = readdlm("companylist.csv",',')

na = Data[:,3].!="n/a"
na[1] = false
New_Data = Data[na,:]

sig_raw = digits.(Int.(ceil.(New_Data[:,3])))
sig = [d[end] for d in sig_raw]

x = range(1,9)
benford = log10.(1 .+(1 ./x))

choose = Int.(ceil.(rand(90).*length(sig)))
samp90 = sig[choose]
choose = Int.(ceil.(rand(900).*length(sig)))
samp900 = sig[choose]

h90 = fit(Histogram,samp90)
h900 = fit(Histogram,samp900)

print(ChisqTest(h90.weights))
print(ChisqTest(h900.weights))
print(ChisqTest(h90.weights,benford))
print(ChisqTest(h900.weights,benford))

print(ChisqTest(h90.weights,h90.weights/sum(h90.weights)))
print(ChisqTest(h900.weights,h900.weights/sum(h900.weights)))

histogram(samp90,normed=true,bins=10)
xticks!(x)
plot!(x,benford)
title!("Financial Fraud Analysis")
