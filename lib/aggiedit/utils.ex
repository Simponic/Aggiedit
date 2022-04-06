defmodule Aggiedit.Utils do
  def get_email_domain(email) do
    domain_split = Regex.named_captures(~r/^.*@(?<domain>.*)$/, email)["domain"]
    |> String.downcase()
    |> String.split(".")
    IO.puts(inspect(domain_split))

    if Enum.count(domain_split) >= 2 do
      Enum.join(Enum.take(domain_split, -2), ".")
    else
      nil
    end
  end
end