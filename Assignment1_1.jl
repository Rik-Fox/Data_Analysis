using Distributions,SpecialFunctions,Statistics,DataFrames
using HypothesisTests,Plots,Random,DelimitedFiles,Pkg
using StatsBase
Pkg.add("LaTeXStrings")
pyplot()

Data = readdlm("companylist.csv",',')

na = Data[:,3].!="n/a"
na[1] = false
New_Data = Data[na,:]

for i=1:length(New_Data[:,3])
    if New_Data[:,3][i] < 0
        New_Data[i] = New_Data[:,3][i]*10
    end
end


sig_raw = digits.(Int.(ceil.(New_Data[:,3])))

sig = [d[end] for d in sig_raw]

x = range(1,9)
benford = log10.(1 .+(1 ./x))

choose = Int.(ceil.(rand(90).*length(sig)))
samp90 = sig[choose]
choose = Int.(ceil.(rand(900).*length(sig)))
samp900 = sig[choose]

h90 = fit(Histogram,samp90).weights
h900 = fit(Histogram,samp900).weights

uni = ones(9)./9

sum(uni)

uni_chisq90 = 90*sum((((h90./90).-uni).^2)./uni)
uni_chisq900 = 900*sum((((h900./900).-uni).^2)./uni)
uni_p90 = 1-cdf(Chisq(8),uni_chisq90)
uni_p900 = 1-cdf(Chisq(8),uni_chisq900)

chisq90 = 90*sum((((h90./90).-benford).^2)./benford)
chisq900 = 900*sum((((h900./900).-benford).^2)./benford)

p90 = 1-cdf(Chisq(8),chisq90)
p900 = 1-cdf(Chisq(8),chisq900)

ChisqTest(h90)
ChisqTest(h900)

ChisqTest(h90,benford)
ChisqTest(h900,benford)

histogram(samp900,normed=true,bins=9,label="Raw Counts")
plot!(x,benford,label = "Benfords Law")
xlabel!("First Significant Figure")
ylabel!("Digit Density")
xticks!(x)
title!("Financial Fraud Analysis Using Benford's Law with N=900")
#savefig("Benford_900")
