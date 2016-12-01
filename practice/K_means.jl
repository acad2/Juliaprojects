#this is a script to implement K means clustering algorithm
workspace()
#first creating a dataframe
using DataFrames
sample = DataFrame(A=randn(20), B=randn(20), C=randn(20))

#the number of clusters to be partitioned into be K=2
K=2
N = length(sample[1,:])
M = length(sample[:,1])
#let the cluster be represented by two arrays each containing
#the index of the feature vector present in the clusters
cluster1 = Int[]
cluster2 = Int[]

#the lower limit difference vector
eps=1e-8

#to assign the the intial mean values m1 and m2 let us pick two
#vectors out of 20 vectors randomly
v1 = rand(1:length(sample[:,1]))
v2 = rand(1:length(sample[:,1]))
#mean vectors are
m1=Number[]
m2=Number[]
for i=1:N
  push!(m1,sample[v1,i])
  push!(m2,sample[v2,i])
end
m1_prev = zeros(Number,length(m1))
m2_prev = zeros(Number,length(m2))

#the distance function
function distance(m,x)
    return norm(m-x)
end

cluster1prev=Int[]
cluster2prev=Int[]
counter=0
while ((distance(m1_prev,m1)>eps && distance(m2_prev,m2)>eps) && counter<250)
  println("debug! Inside while")
  for i=1:M
    #calculating distances from both the means
    x=Number[]
    for k=1:N
      push!(x,sample[i,k])
    end
    d1=distance(m1,x)
    d2=distance(m2,x)
    if d1<=d2
      push!(cluster1,i)
    else
      push!(cluster2,i)
    end
  end
  #recalculating the mean using clusters
  m1_prev = m1
  m2_prev = m2
  m1 = Number[]
  m2 = Number[]
  #we will calculate the sum vector first
  for i=1:N
    s1=0
    s2=0
    for j=1:length(cluster1)
      s1+=sample[j,i]
    end
    push!(m1,s1)
    for j=1:length(cluster2)
      s2+=sample[j,i]
    end
    push!(m2,s2)
  end
  m1 = m1/length(cluster1)
  m2 = m2/length(cluster2)
  counter +=1
  cluster1prev = cluster1
  cluster2prev = cluster2
  #clusters should be empty before both the iteration
  cluster1 = Int[]
  cluster2 = Int[]
end
cluster1 = cluster1prev;
cluster2 = cluster2prev;
