defmodule Bank do
  def account(balance) do
    input = IO.gets("D)eposit, W)ithdraw, B)alance, Q)uit: ")
    action = char_to_action(String.first(input))
    if action != :quit do
      new_balance = transaction(action, balance)
      account(new_balance)
    end
  end

  defp char_to_action(input) do
    letter = String.first(input) |> String.upcase
    case letter  do
      "D"  -> :deposit
      "W"  -> :withdraw
      "B"  -> :balance
      "Q"  -> :quit
      _    -> letter
    end
  end

  defp transaction(:deposit, balance) do
    amount = get_number("Amount to withdraw: ")
    cond do
      amount > 10_000 ->
        :error_logger.warning_msg("Large deposit $#{amount}\n")
        IO.puts("Your deposit of $#{amount} may be subject to hold.")
        new_balance = balance + amount
        IO.puts("Your new balance is $#{new_balance}")
      amount < 0 ->
        :error_logger.error_msg("Negative deposit $#{amount}\n")
        IO.puts("Deposits may not be less than zero.")
        new_balance = balance
      true ->
        :error_logger.info_msg("Successful deposit of $#{amount}\n")
        new_balance = balance + amount
        IO.puts "Your new balance is $#{new_balance}"
    end
    new_balance
  end

  defp transaction(:withdraw, balance) do
    amount = get_number("Amount to deposit: ")
    cond do
      amount > balance ->
        :error_logger.error_msg("Overdraw $#{amount} from $#{balance}\n")
        IO.puts("You cannot withdraw more than your current balance of $#{balance}")
        new_balance = balance
      amount < 0 ->
        :error_logger.error_msg("Negative withdrawal amount $#{amount}\n")
        IO.puts("Withdrawals may not be less than zero.")
        new_balance = balance
      true ->
        :error_logger.info_msg("Successful withdrawal $#{amount}\n")
        new_balance = balance - amount
        IO.puts("Your new balance is $#{new_balance}")
    end
    new_balance
  end

  defp transaction(:balance, balance) do
    :error_logger.info_msg("Balance inquiry $#{balance}\n")
    IO.puts("Your current balance is $#{balance}")
    balance
  end

  defp transaction(letter, balance) do
    IO.puts("Unknown command #{letter}")
    balance
  end

  def get_number(prompt) do
    input = IO.gets("#{prompt}")
    input_str = String.strip(input)
    cond do
      Regex.match?(~r/^[+-]?\d+$/, input_str) ->
        :erlang.binary_to_integer(String.strip(input_str))
      Regex.match?(~r/^[+-]?\d+\.\d+([eE][+-]?\d+)?$/, input_str) ->
        :erlang.binary_to_float(String.strip(input_str))
      true -> :error
    end
  end
end