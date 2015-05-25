#----------------------------------------
#-- Random "gradient descent"
#----------------------------------------
include("offlineAssignment.jl")

function randomDescentOrder(pb::TaxiProblem, n::Int, start::Vector{Int} = [1:length(pb.custs)])
  initT = time()
  sp = pb.sp

  order = start
  bestCost = Inf
  bestSol = 0

  bestCost, bestSol = offlineAssignment(pb, order)
  println("Try: 1, $(-bestCost) dollars")

  for trys in 2:n
    #We do only on transposition from the best costn
    i = rand(1:length(order))
    j = i
    while i == j
      j = rand(1:length(order))
    end

    order[i], order[j] = order[j], order[i]

    cost, sol = offlineAssignment(pb, order)
    if cost <= bestCost
      if cost < bestCost
        println("====Try: $(trys), $(-cost) dollars")
        bestSol = sol
      end
      bestCost = cost
      order[i], order[j] = order[j], order[i]
    end
    order[i], order[j] = order[j], order[i]
  end
  println("Final: $(-bestCost) dollars")
  cpt, nt = customers_per_taxi(length(pb.taxis),bestSol)
  tp = taxi_paths(pb,bestSol,cpt)

  taxiActs = Array(TaxiActions,length(pb.taxis))
  for i = 1:length(pb.taxis)
    taxiActs[i] = TaxiActions(tp[i],cpt[i])
  end
  return (TaxiSolution(taxiActs, nt, bestSol, bestCost), order)
end
randomDescent(pb::TaxiProblem, n::Int, start::Vector{Int} = [1:length(pb.custs)]) =
  randomDescentOrder(pb,n,start)[1]