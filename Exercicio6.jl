using JuMP
using Ipopt
using LinearAlgebra
using Plots

n=1000
model = Model(Ipopt.Optimizer)

@variable(model,x[1:n+1])
@variable(model,u[1:n+1])

@NLobjective(model, Min, sum((n/2)*((x[i]*sqrt(1+u[i]^2))+(x[i+1]*sqrt(u[i+1]^2))) for i in 1:n))

@NLconstraint(model, x[1] == 1)
@NLconstraint(model, x[n+1] == 3)
for i in 1:n
    @NLconstraint(model, x[i+1]-x[i] == (n/2)*(u[i]+u[i+1]))
    @NLconstraint(model, ((n/2)*(sqrt(1+u[i]^2)+sqrt(1+u[i+1]^2))) == 3)
end
optimize!(model)

port = plot(range(0,1,length=n+1),value.(x),m=(3,:blue),leg=false,title = "L = 3")

savefig(port,"plot3.png")