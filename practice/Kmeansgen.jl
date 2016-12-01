#this is a script to implement K means clustering algorithm
workspace()
#first creating a dataframe analysis on iris dataset from R
using DataFrames
using RDatasets
iris = dataset("datasets","iris")
sample = iris[:,1:end-1]

#the number of clusters to be partitioned into be K and other constants
K=5; N = length(sample[1,:]); M = length(sample[:,1])

cls = zeros(M) #cls[i] stores the cluster to which ith row belongs
clsprev = zeros(M)
#the lower limit difference vector
eps=1e-8

#to assign the the intial mean values let us pick K vectors out of 20 vectors randomly
randomIndices = rand(1:M,K)
meanVecs = Array{Number}(K,N)
for i=1:K
  temp=Number[]
  temp=[sample[i,j] for j=1:N]
  meanVecs[i,:]=temp
end

#the distance function
function distance(m,x)
    return norm(m-x)
end

#the minimum function
function min(d)
  return minimum(d) #d[] is the vector which contains distances of vector x from means
end
meanVecsprev = Array{Number}(K,N)
meanVecsprev = [0 for i=1:K,j=1:N]

function boolf(meanVecs,meanVecsprev)
  b=false
  [b=b||(norm(meanVecs[i,:]-meanVecsprev[i,:]) > eps) for i=1:K]
  return b
end

counter=0
@time while (boolf(meanVecs,meanVecsprev) && counter<250)
  for i=1:M
    x=Number[]
    x=[sample[i,k] for k=1:N]
    dist=Number[]
    dist=[distance(meanVecs[j,:],x) for j=1:K]
    ind = 0
    ind = findin(dist, minimum(dist))
    cls[i] = ind[1]
  end
  #Recalculating mean using elements in clusters
  meanVecsprev = meanVecs
  for i=1:K
      s=zeros(N)
      lencount=0
      for j=1:M
        x=Number[]
        if cls[j]==i
          x=[sample[i,l] for l=1:N]
          s +=x
          lencount+=1
        end
      end
      meanVecs[i,:] = s/lencount
  end
  clsprev = cls
  cls = zeros(M)
  counter+=1
end
