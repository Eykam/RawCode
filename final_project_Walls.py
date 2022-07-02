import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math



def read_data(file):
    df = pd.read_csv(file)
    df['Date'] = pd.to_datetime(df['Date'])
    return df



def data_statistics(dataframe):
    print(dataframe.drop(columns="Date").describe())
    print("\n")



def make_transaction(account, price, quantity, buy):
    trans_price = round(price * quantity,2)
    quant = quantity
    if buy:
        if trans_price > account['Balance']:
            quant = math.floor(account['Balance']/price)
            trans_price = price*quant

        print("----------------Buy Order----------------")
        print("Quantity Bought: " + "{:.2f}".format(quant) + "        " + "Price Bought: " + "{:.2f}".format(price))
        print("Account Balance (Before): " + "{:.2f}".format(account['Balance']) + "        " +
              "Stock Quantity (Before): " + "{:.2f}".format(account['Stock_Quantity']))
        account['Balance'] = round(account['Balance'] - trans_price,2)
        account['Stock_Quantity'] = account['Stock_Quantity'] + quant
        print("Account Balance (After) : " + "{:.2f}".format(account['Balance']) + "        " +
              "Stock Quantity (After) : " + "{:.2f}".format(account['Stock_Quantity']))
        print("Total Transaction cost  : -" + "{:.2f}".format(trans_price)+"\n")

        return True

    else:
        if quantity > account['Stock_Quantity']:
            trans_price = round(price*account['Stock_Quantity'],2)
            quant = account['Stock_Quantity']

        if(quant != 0):
            print("----------------Sell Order----------------")
            print("Quantity Sold: " + "{:.2f}".format(quant) + "        " + "Price Sold: " + "{:.2f}".format(price))
            print("Account Balance (Before): "+ "{:.2f}".format(account['Balance']) + "        " +
                                                "Stock Quantity (Before): " + "{:.2f}".format(account['Stock_Quantity']))
            account['Balance'] = round(account['Balance'] + trans_price,2)
            account['Stock_Quantity'] = account['Stock_Quantity'] - quant
            print("Account Balance (After) : " + "{:.2f}".format(account['Balance']) + "        " +
                                                "Stock Quantity (After) : " + "{:.2f}".format(account['Stock_Quantity']))
            print("Total Transaction cost  : +" + "{:.2f}".format(trans_price)+"\n")

            return True
        return False



def get_sma(dataframe):
    return(dataframe['Open'].rolling(10).mean())



def trade(dataframe, sma, account):
    trades = []

    for ind in range(0,len(sma)):
        price = dataframe.iloc[ind]['Open']

        if (price*(1.05)) > sma[ind]:
            if (make_transaction(account, price, 10, False)):
                trades.append(-1)
            else:
                trades.append(0)
        elif (price*(.95)) < sma[ind]:
            make_transaction(account, price, 10, True)
            trades.append(1)
        else:
            trades.append(0)
    return(trades)



def make_plot(dataframe, sma, trades):
    plt.figure(figsize=(10, 8))
    plt.plot_date(dataframe['Date'],dataframe['Open'], markersize=4, label='Open Price')
    plt.plot_date(dataframe['Date'],sma, 'xr-',markersize=2, label= "10-day SMA")
    plt.xlabel('Date')
    plt.ylabel('Stock Price (US Dollars)')
    plt.title('AAPL (12/2019 - 12/2020)')

    x_buy = []
    y_buy = []

    x_sell = []
    y_sell = []

    for ind in range(0,len(trades)):
        x = dataframe.iloc[ind]['Date']
        y = dataframe.iloc[ind]['Open']
        if trades[ind] == 1:
            x_buy.append(x)
            y_buy.append(y)
        elif trades[ind] == -1:
            x_sell.append(x)
            y_sell.append(y)

    plt.plot_date(x_buy,y_buy,'go',markersize=7, label="Buy Position")
    plt.plot_date(x_sell, y_sell, 'ro', markersize=7, label="Sell Position")
    plt.legend()
    plt.show()
    plt.close()


def main():
    acc = {"Balance": 100000.0,
           "Stock_Quantity": 0}
    df = read_data('AAPL.csv')
    data_statistics(df)
    sma = get_sma(df)
    trades = trade(df,sma,acc)
    print("Buy and Sell Records: ")
    print(trades)
    make_plot(df,sma,trades)

if __name__ == "__main__":
    main()