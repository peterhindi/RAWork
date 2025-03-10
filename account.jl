include("data_read.jl")
mutable struct Account
     trade_size
     balance #initialize with starting balance  
     trades
       
     function Account(trade_size)
          new(trade_size, 0, [])
     end

end

function open_trade(account::Account,  model::Modelrun)
     trades = account.trades
     new_trades = push!(trades, model)
     account.trades = new_trades
end

function close_trade(account::Account, model::Modelrun)
     trades = account.trades
     new_trades = filter!(e->e!=model, trades)
     account.trades = new_trades
end

function update_balance(account::Account, current_time, time_delta)
     time_delta
     level_2_df = []
     balance = account.balance
     
     for df in twoddf
          semi_df = filter(row -> row.transaction_time >= (current_time-time_delta), df)
          push!(level_2_df, filter(row -> row.transaction_time < current_time, semi_df))               
     end

     if all(isempty,level_2_df) 
          println("No returns data in the timeline specified: From $(current_time - time_delta) to $current_time. Maintaining existing balance and moving to next iteration.")
     else
          for trade in account.trades
               for asset in trade.buy_array
                    balance += (last(level_2_df[asset][!, "best_bid_price"]) - first((level_2_df[asset][!, "best_ask_price"])))
               end

               for asset in trade.sell_array
                    balance += (first(level_2_df[asset][!, "best_bid_price"]) - last((level_2_df[asset][!, "best_ask_price"])))
               end
          end
     end
     account.balance = balance

end