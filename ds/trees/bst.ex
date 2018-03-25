defmodule BST do
  @moduledoc """
  BST using tuple representation.

  TODO: benchmark
  TODO: tail recursion where possible
  TODO: property testing 
  """
  def new do
    nil
  end

  def insert(nil, key, value) do
    {nil, {key, value}, nil}
  end
  def insert({left, current = {key, _value}, right}, new_key, new_value) do
    if new_key < key do
      {insert(left, new_key, new_value), current, right}
    else
      if new_key > key do
        {left, current, insert(right, new_key, new_value)}
      else
        {left, {new_key, new_value}, right}
      end
    end
  end


  def get(nil, _target_key), do: nil
  def get({left, {key, value}, right}, target_key) do
    if target_key < key do
      get(left, target_key)
    else
      if target_key > key do
        get(right, target_key)
      else
        value
      end
    end
  end


  def remove(nil, _target_key), do: nil
  def remove(node = {left, current = {key, _value}, right}, target_key) do
    if target_key < key do
      {remove(left, target_key), current, right}
    else
      if target_key > key do
        {left, current, remove(right, target_key)}
      else
        remove(node)
      end
    end
  end


  def size(nil), do: 0
  def size({left, _, right}), do: size(left) + 1 + size(right)


  def heights(nil), do: nil
  def heights({left, _, right}), do: {height(left), height(right)}


  defp height(nil), do: 0
  defp height({left, _, right}), do: 1 + max(height(left), height(right))


  defp remove({nil, _, nil}), do: nil
  defp remove({left, _, nil}), do: left
  defp remove({nil, _, right}), do: right
  defp remove({left, _, right}) do
    {first_smaller_key, first_smaller_value, new_left} = remove_last_right(left)
    {new_left, {first_smaller_key, first_smaller_value}, right}
  end


  defp remove_last_right({first_left, current, {right_left, {right_key, right_value}, nil}}) do
    {right_key, right_value, {first_left, current, right_left}}
  end
  defp remove_last_right({left, current, right}) do
    {key, value, new_right} = remove_last_right(right)
    {key, value, {left, current, new_right}}
  end
end


defmodule BST.Test do
  def test1 do
    kv_pairs = (for x <- 0..1000, do: {x, x * x}) |> Enum.shuffle
    tree = BST.new

    Enum.reduce(
      kv_pairs,
      tree,
      fn {k, v}, tree_acc ->
        BST.insert(tree_acc, k, v)
      end
    )
  end
end
