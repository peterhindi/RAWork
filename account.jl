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

function update_balance(account::Account, window_df)
     balance = account.balance
     
     if all(isempty,window_df) 
          println("No returns data in the timeline specified. Maintaining existing balance and moving to next iteration.")
     else
          for trade in account.trades
               for asset in trade.buy_array
                    balance += (last(window_df[asset][!, "best_bid_price"]) - first((window_df[asset][!, "best_ask_price"])))
               end

               for asset in trade.sell_array
                    balance += (first(window_df[asset][!, "best_bid_price"]) - last((window_df[asset][!, "best_ask_price"])))
               end
          end
     end
     account.balance = balance
end

function trade_closing_logic(account::Account, window_df)

     if isempty(account.trades)
          println("No trades opened at the current time period. No closings available")
     else
          #iterate through each open trade and update the spread for the current period
          for trade in account.trades
               if isempty(trade.pair) || all(isempty, window_df)
                    println("Trade has not been instantiated with a pair, or the dataframe is empty")
               else
                    sell_asset = trade.pair[1]
                    buy_asset = trade.pair[2]
                    println(sell_asset)
                    println(buy_asset)
                    display(window_df[1])
                    #calculate the initial spread
                    initial_spread = first(window_df[sell_asset][!, "best_bid_price"]) - first(window_df[buy_asset][!, "best_ask_price"])
                    
                    #calculate the current spread at model run
                    current_spread = abs(last(window_df[trade.pair[1]][!, "best_bid_price"]) - last(window_df[trade.pair[2]][!, "best_ask_price"]))
                    
                    #if the spread decreased, close the trade
                    if current_spread < initial_spread
                         close_trade(account, trade)
                    end
               end
          end
     end
end