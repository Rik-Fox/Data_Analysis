using Distributions,SpecialFunctions,Statistics,HypothesisTests
using StatsBase,Plots,Random
pyplot()


x = collect(60:1:90)        #for range of 0 to 100 marks

#### Population Distribution
μ = 75
σ_pop = 7

pop_dist = fit(Normal(μ,σ_pop),x)

CDF_pop = cdf(Normal(μ,σ_pop),x)

#### Sample Distribution
N = 30              #number of children in class
samp_mean = 72
σ_sem = σ_pop/sqrt(N)

samp_dist = Normal(samp_mean,σ_sem)

CDF_samp = cdf(Normal(samp_mean,σ_sem),x)

#### 1 sided
thres_1 = invlogcdf(Normal(samp_mean,σ_sem),log(0.99))

thres_5 = invlogcdf(Normal(samp_mean,σ_sem),log(0.95))


#### 2 sided
lower_1  = invlogcdf(Normal(samp_mean,σ_sem),log(0.005))
upper_1 = invlogcdf(Normal(samp_mean,σ_sem),log(0.995))

lower_5  = invlogcdf(Normal(samp_mean,σ_sem),log(0.025))
upper_5 = invlogcdf(Normal(samp_mean,σ_sem),log(0.975))

fillrange1_1 = invlogcdf(Normal(samp_mean,σ_sem),log(0.00001)):100:thres_1
fillrange1_5 = 0:1:thres_5
fillrange2_1 = lower_1:100:upper_1
fillrange2_5 = lower_5:1:upper_5

plot(x,pdf.(samp_dist,x), fill = (-thres_5:thres_5,0, :red))
