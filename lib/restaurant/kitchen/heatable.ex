defprotocol Restaurant.Kitchen.Heatable do
  @spec heat_up(t()) :: t()
  def heat_up(t)
end

defimpl Restaurant.Kitchen.Heatable, for: Any do
  def heat_up(t), do: t
end
