using Distributions,SpecialFunctions,Statistics,HypothesisTests
using StatsBase,Plots,Random
pyplot()


x = collect(60:1:90)        #for range of 0 to 100 marks

#### Population Distribution
μ = 75
σ_pop = 7

#### Sample
N = 30              #number of children in class
σ_sem = σ_pop/sqrt(N)


#### Z-Statistic
z = (72-μ)/σ_sem

#### 1 sided
thres_1 = invlogcdf(Normal(),log(0.01))

thres_5 = invlogcdf(Normal(),log(0.05))


#### 2 sided
lower_1  = invlogcdf(Normal(),log(0.005))
upper_1 = invlogcdf(Normal(),log(0.995))

lower_5  = invlogcdf(Normal(),log(0.025))
upper_5 = invlogcdf(Normal(),log(0.975))

##### p value

p = cdf(Normal(),z)
