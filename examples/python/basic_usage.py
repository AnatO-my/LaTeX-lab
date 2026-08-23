from otmath import (
    MathOperation,
    MathRequest,
    render_steps_text,
    run_request,
    solve_expression,
    solve_system,
)

result = solve_expression("x**2 - 5*x + 6")
print(result.answers)
print(result.latex)
print(result.verified)
print(result.metadata)
print(render_steps_text(result.steps))

request = MathRequest(
    operation=MathOperation.FACTOR,
    expression="x**2 - 5*x + 6",
)
factored = run_request(request)
print(factored.answers)
print(factored.verified)
print(factored.metadata)

system = solve_system(["x + y = 5", "x - y = 1"], variables=["x", "y"])
print(system.answers)
print(system.verified)
print(system.metadata)
