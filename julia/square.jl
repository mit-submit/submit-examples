# This simple test code reads numbers from a file "input-x", squares them, and
# writes (appending) to an output file "output-x"

function square(source)
    f = open("input")
    o = open("output", "a")
    s = readline(f)
    while s != ""
        v = parse(Int, s)
        m = string(v^2, "\n")
        s = readline(f)
        write(o, m)
    end
    close(o)
    close(f)
end

square(ARGS[1])
