using Distributions,SpecialFunctions,Statistics,DataFrames
using HypothesisTests,Plots,Random,DelimitedFiles,Pkg
using StatsBase
Pkg.add("LaTeXStrings")
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

ChisqTest(h90.weights)
ChisqTest(h900.weights)

ChisqTest(h90.weights,benford)
ChisqTest(h900.weights,benford)

histogram(samp900,normed=true,bins=10,label="Raw Counts")
plot!(x,benford,label = "Benfords Law")
xlabel!("First Significant Figure")
ylabel!("Digit Density")
xticks!(x)
title!("Financial Fraud Analysis Using Benford's Law with N=900")
savefig("Benford_900")
