module Enumerable
  def my_each
    i = 0
    while i < self.length
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < self.length
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    i = 0
    results = []
    while i < self.length
      results.push(self[i]) if yield(self[i])
      i += 1
    end
    results
  end

  def my_all?
    i = 0
    while i < self.length
      if yield(self[i])
        i += 1
      else
        return false
      end
    end
    return true
  end

  def my_any?
    i = 0
    while i < self.length
      return true if yield(self[i])
      i += 1
    end
    return false
  end

  def my_none?
    i = 0
    while i < self.length
      return false if yield(self[i])
      i += 1
    end
    return true
  end

  def my_count
    return self.length
  end

  def my_map
    results = []
    self.my_each {|x| results.push(yield(x))}
    results
  end

  def my_map_with_proc(&proc)
    results = []
    self.my_each {|x|
      results.push(&proc.call(x))
      results.push(yield(x)) if block_given?
    }
    results
  end

  def my_inject(*args)
    #This is a substantially longer method than I care for, but I'm not sure how else to support each of the different forms of the method. To simplify, I'd go ahead and break the variable assignment out to its own method and, potentially, do the same for the while loop.

    #Note: I made a quick attempt at breaking the assignment section out to its own method and ended up needing 4 arguments for configuration which seems somewhat heavily entangled. I imagine there's a simple enough way to refactor that (and this whole module), but for purposes of this exercise I think it's sufficient. Comments and suggestions welcome.
    return "Too many arguments" if args.length > 2

    i = 0
    memo = ""

    if (args[0].instance_of? Fixnum) && (args[1].instance_of? Symbol)
      memo, sym = args[0], args[1]
    elsif args[0].instance_of? Symbol
      sym, memo, i = args[0], self[0], 1
    elsif args[0].instance_of? Numeric
      memo = args[0]
    end

    while i < self.length
      if block_given?
        memo = yield(memo, self[i])
      else
        memo = memo.send sym, self[i]
      end
      i+=1
    end
    return memo
  end


end
