defmodule AdderTest do
  @moduledoc "Vanilla, requires ordering a and b correctly if one relies upon the other"

  use ExUnit.Case, async: true

  describe "add/2 with a = 1, b = 1" do
    setup [:a_1, :b_1]

    test "gives the correct answer", context do
      assert Adder.add(context.a, context.b) == 2
    end
  end

  describe "add/2 with a = 1, b = 2" do
    setup [:a_1, :b_2]

    test "gives the correct answer", context do
      assert Adder.add(context.a, context.b) == 3
    end
  end

  describe "add/2 with a = 2, b = 1" do
    setup [:a_2, :b_1]

    test "gives the correct answer", context do
      assert Adder.add(context.a, context.b) == 3
    end
  end

  describe "add/2 with a = 2, b = 2" do
    setup [:a_2, :b_2]

    test "gives the correct answer", context do
      assert Adder.add(context.a, context.b) == 4
    end
  end

  describe "add/2 with a = b, b = 15" do
    # must be around the right way since a depends on context.b
    setup [:b_15, :a_b]

    test "gives the correct answer", context do
      assert Adder.add(context.a, context.b) == 30
    end
  end

  def a_1(context), do: put_in(context, [:a], 1)
  def a_2(context), do: put_in(context, [:a], 2)
  def b_1(context), do: put_in(context, [:b], 1)
  def b_2(context), do: put_in(context, [:b], 2)
  def b_15(context), do: put_in(context, [:b], 15)
  def a_b(context), do: put_in(context, [:a], context.b)
end

# --- lazy with functions

defmodule LazyContextCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import LazyContextCase.Helpers
    end
  end

  defmodule Helpers do
    def set(context, var, f) do
      put_in(context, [var], f)
    end

    def get(context, var) do
      lazy_eval(context, Map.get(context, var))
    end

    defmacro let(var, expr) do
      quote do
        setup context do
          set(context, unquote(var), unquote(expr))
        end
      end
    end

    defp lazy_eval(context, f) when is_function(f) do
      f.(context)
    end

    defp lazy_eval(_context, val) do
      val
    end
  end
end

defmodule AdderWithFunctionsTest do
  @moduledoc "Functions are lazily evaluated, so we don't have to order the terms right during setup"

  use LazyContextCase, async: true

  describe "add/2 with a = 1, b = 1" do
    let :a, 1
    let :b, 1

    test "gives the correct answer", context do
      assert Adder.add(get(context, :a), get(context, :b)) == 2
    end
  end

  describe "add/2 with a = 1, b = 2" do
    let :a, 1
    let :b, 2

    test "gives the correct answer", context do
      assert Adder.add(get(context, :a), get(context, :b)) == 3
    end
  end

  describe "add/2 with a = 2, b = 1" do
    let :a, 2
    let :b, 1

    test "gives the correct answer", context do
      assert Adder.add(get(context, :a), get(context, :b)) == 3
    end
  end

  describe "add/2 with a = 2, b = 2" do
    let :a, 2
    let :b, 2

    test "gives the correct answer", context do
      assert Adder.add(get(context, :a), get(context, :b)) == 4
    end
  end

  describe "add/2 with a = b, b = 15" do
    let :a, fn context -> get(context, :b) end # order is not important
    let :b, 15

    test "gives the correct answer", context do
      assert Adder.add(get(context, :a), get(context, :b)) == 30
    end
  end
end

# --- lazy with ETS

defmodule EtsContextCase do
  @moduledoc "Use global ETS table instead of test context object"

  use ExUnit.CaseTemplate

  using do
    quote do
      import EtsContextCase.Helpers
    end
  end

  setup do
    :ets.new(:ex_unit, [:named_table])
    :ok
  end

  defmodule Helpers do
    def get(var, f) do
      :ets.insert(:ex_unit, {var, f})
      :ok
    end

    def get(var) do
      case :ets.lookup(:ex_unit, var) do
        [{^var, val}] -> val.()
        [] -> nil
      end
    end

    defmacro let(var, expr) do
      quote do
        setup do
          get(unquote(var), fn -> unquote(expr) end)
        end
      end
    end
  end
end

defmodule AdderWithEtsTest do
  use EtsContextCase, async: true

  describe "add/2 with a = 1, b = 1" do
    let :a, 1
    let :b, 1

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 2
    end
  end

  describe "add/2 with a = 1, b = 2" do
    let :a, 1
    let :b, 2

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 3
    end
  end

  describe "add/2 with a = 2, b = 1" do
    let :a, 2
    let :b, 1

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 3
    end
  end

  describe "add/2 with a = 2, b = 2" do
    let :a, 2
    let :b, 2

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 4
    end
  end

  describe "add/2 with a = b, b = 15" do
    # order is not important
    let :a, get(:b)
    let :b, 15

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 30
    end
  end
end

# --- lazy with Agent

defmodule AgentContextCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import AgentContextCase.Helpers
    end
  end

  @name :ex_unit

  setup do
    {:ok, _pid} = Agent.start_link(fn -> %{} end, name: @name)
    :ok
  end

  defmodule Helpers do
    @name :ex_unit

    def get(var, f) do
      Agent.update(@name, fn state -> Map.put(state, var, f) end)
      :ok
    end

    def get(var) do
      case Agent.get(@name, fn state -> Map.get(state, var) end) do
        nil -> nil
        f -> f.()
      end
    end

    defmacro let(var, expr) do
      quote do
        setup do
          get(unquote(var), fn -> unquote(expr) end)
        end
      end
    end
  end
end

defmodule AdderWithAgentTest do
  use AgentContextCase, async: true

  describe "add/2 with a = 1, b = 1" do
    let :a, 1
    let :b, 1

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 2
    end
  end

  describe "add/2 with a = 1, b = 2" do
    let :a, 1
    let :b, 2

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 3
    end
  end

  describe "add/2 with a = 2, b = 1" do
    let :a, 2
    let :b, 1

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 3
    end
  end

  describe "add/2 with a = 2, b = 2" do
    let :a, 2
    let :b, 2

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 4
    end
  end

  describe "add/2 with a = b, b = 15" do
    # order is not important
    let :a, get(:b)
    let :b, 15

    test "gives the correct answer" do
      assert Adder.add(get(:a), get(:b)) == 30
    end
  end
end
