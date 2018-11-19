using Distributions
using SpecialFunctions
using Statistics
using StatsBase
using DelimitedFiles
# using PyPlot
using HypothesisTests
using Plots

trueMean=50
trueVar=9
n=5
dx=0.1


Sample=rand(Normal(trueMean,sqrt(trueVar)),n)
sampleMean=mean(Sample)
sampleVar=var(Sample)
meanAxis=collect(sampleMean-1.96*sqrt(sampleVar):dx:sampleMean+1.96*sqrt(sampleVar))
varAxis=collect(dx:dx:2*sampleVar)

L=zeros(length(varAxis),length(meanAxis))

function pdfsum(mu,std,x)
    summy=1
    for i in 1:length(x)
        summy*=pdf(Normal(mu,std),x[i])
    end
    return summy
end

for i in 1:length(meanAxis)
    for j in 1:length(varAxis)
        L[end+1-j,i]=pdfsum(meanAxis[i],sqrt(varAxis[j]),Sample)
    end
end

# prior/length(prior)

prior=ones(length(varAxis),length(meanAxis))
prob_of_data=sum(L .* prior/length(prior))

posterior=L .* prior /prob_of_data

heatmap(meanAxis,varAxis,posterior)

#Using posterior as prior

# prior2=posterior
# posterior2=L .* prior2 /prob_of_data
# heatmap(meanAxis,varAxis,posterior2)
#
# prior3=posterior2
# posterior3=L .* prior3 /prob_of_data
# heatmap(meanAxis,varAxis,posterior3)
